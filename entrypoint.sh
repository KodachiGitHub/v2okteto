#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="temp_dir"

mkdir -p temp_dir

PORT=2048
PASSWORD=password



# Get V2Ray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o temp_dir/v2ray_dist.zip
busybox unzip temp_dir/v2ray_dist.zip -d temp_dir

# Convert to protobuf format configuration
mkdir -p config
# Write V2Ray configuration
cat << EOF > config/config.json
{
    "inbounds": [{
            "port": ${PORT},
            "protocol": "shadowsocks",
            "settings": {
            "method": "aes-128-gcm",
            "ota": true,
            "password": "${PASSWORD}"
      }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Install V2Ray
#install -m 755 temp_dir/v2ray ${DIR_RUNTIME}
#rm -rf temp_dir

# Run V2Ray
chmod +x temp_dir/v2ray
temp_dir/v2ray -config=config/config.json
