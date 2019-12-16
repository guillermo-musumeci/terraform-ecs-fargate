#!/bin/bash

if [ -e /dev/nvme1n1 ]; then
	if ! file -s /dev/nvme1n1 | grep -q filesystem; then
		mkfs.ext4 /dev/nvme1n1
	fi

	cat >> /etc/fstab <<-EOF
	/dev/nvme1n1  /data  ext4  defaults,noatime,nofail  0  2
	EOF

	mkdir /data
	mount /data
fi

echo ECS_CLUSTER=${ecs_cluster} >> /etc/ecs/ecs.config
systemctl try-restart ecs --no-block
