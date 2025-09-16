#!/usr/bin/env bash
set -euo pipefail

DEST=/run/media/rcrumana/backup
SRC_TOP=/mnt/srcfs
sudo mkdir -p "$DEST/@snapshots"

bases=(root home var tmp media)
keep=1
now=$(date +%Y%m%d-%H%M%S)

for base in "${bases[@]}"; do
  live="$SRC_TOP/@$base"
  src_snap="$SRC_TOP/@snapshots/${base}-daily-${now}"
  echo "Snapshotting $live → $src_snap"
  sudo btrfs subvolume snapshot -r "$live" "$src_snap"

parent=$(sudo btrfs subvolume list "$DEST" \
           | awk -v b="$base" '$NF ~ "^@snapshots/" b"-daily-" {print $NF}' \
           | sort | tail -n1)

    if [[ -n "$parent" ]]; then
      parent_name="${parent##*/}"  # strip the leading @snapshots/
      echo "Incremental send ($parent_name → ${src_snap##*/})"
      if [[ -d "$SRC_TOP/@snapshots/$parent_name" ]]; then
        sudo btrfs send -p "$SRC_TOP/@snapshots/$parent_name" "$src_snap" \
          | sudo btrfs receive "$DEST/@snapshots"
      else
        echo "Parent not found on SOURCE; falling back to full send."
        sudo btrfs send "$src_snap" | sudo btrfs receive "$DEST/@snapshots"
      fi
    else
      echo "Full send of first snapshot for @$base"
      sudo btrfs send "$src_snap" | sudo btrfs receive "$DEST/@snapshots"
    fi

  # update writable @<base> on DEST
  sudo btrfs subvolume delete "$DEST/@$base" || true
  sudo btrfs subvolume snapshot "$DEST/@snapshots/${base}-daily-${now}" \
                                "$DEST/@$base"

    sudo btrfs subvolume list "$DEST" \
      | awk -v b="$base" '$NF ~ "^@snapshots/" b"-daily-" {print $2,$NF}' \
      | sort -k2 | head -n -"$keep" | while read -r id path; do
          sudo btrfs subvolume delete "$DEST/$path"
        done

  sudo btrfs subvolume delete "$src_snap"  # clean up source temp snap
done

# point USB’s default subvol to @root
root_id=$(sudo btrfs subvolume list "$DEST" | awk '$NF=="@root"{print $2}')
sudo btrfs subvolume set-default "$root_id" "$DEST"

echo "Backup complete."

