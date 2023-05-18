`docker volume create portainer_data`

```
docker run -d -p 8000:8000 -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:2.11.1
```

- portainer 可以管理多个服务器上的 Docker，所有有 group 和 tag 的概念

# Reference
- [Stack实操_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1Q3411s7S5?p=4&spm_id_from=pageDriver&vd_source=25509bb582bc4a25d86d871d5cdffca3)

