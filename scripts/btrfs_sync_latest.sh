#!/usr/bin/env bash
set -euo pipefail

DEST=/run/media/rcrumana/backup
SRC_TOP=/mnt/srcfs                                           # <- edit

bases=(root home var tmp media)
keep=1
now=$(date +%Y%m%d-%H%M%S)

for base in "${bases[@]}"; do
  live="$SRC_TOP/@$base"
  src_snap="$SRC_TOP/@snapshots/${base}-daily-${now}"
  echo "Snapshotting $live → $src_snap"
  sudo btrfs subvolume snapshot -r "$live" "$src_snap"

  # newest matching snapshot already on DEST (may be empty)
  parent=$(sudo btrfs subvolume list "$DEST/@snapshots" |
           awk -v b="$base" '$NF ~ b"-daily-" {print $NF}' |
           sort | tail -n1)

  if [[ -n "$parent" ]]; then
    echo "Incremental send ($parent → $src_snap)"
    sudo btrfs send -p "$SRC_TOP/@snapshots/$parent" "$src_snap" |
      sudo btrfs receive "$DEST/@snapshots"
  else
    echo "Full send of first snapshot for @$base"
    sudo btrfs send "$src_snap" |
      sudo btrfs receive "$DEST/@snapshots"
  fi

  # update writable @<base> on DEST
  sudo btrfs subvolume delete "$DEST/@$base" || true
  sudo btrfs subvolume snapshot "$DEST/@snapshots/${base}-daily-${now}" \
                                "$DEST/@$base"

  # keep only $keep snapshots
  sudo btrfs subvolume list "$DEST/@snapshots" |
    awk -v b="$base" '$NF ~ b"-daily-" {print $2,$NF}' |
    sort -k2 | head -n -"$keep" |
    while read id path; do
      sudo btrfs subvolume delete "$DEST/@snapshots/$path"
    done

  sudo btrfs subvolume delete "$src_snap"  # clean up source temp snap
done

# point USB’s default subvol to @root
root_id=$(sudo btrfs subvolume list "$DEST" | awk '$NF=="@root"{print $2}')
sudo btrfs subvolume set-default "$root_id" "$DEST"

echo "Backup complete."

