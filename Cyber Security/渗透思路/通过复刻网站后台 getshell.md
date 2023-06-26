- Time：2023-06-26 08:18
- Label： #getshell #渗透思路

## Abstract

1. 通过域名查询备案信息,[[../暗月渗透测试/信息搜集|信息搜集]]
2. CMS 指纹识别 ---> 确定应用建站版本
3. 官方网站文档 ---> 后台页面
4. 代码审计 ---> 意外发现默认的账号密码
5. 上传点 ---> 发现自带文件管理器
6. 上传木马 (一句话木马)，然后访问一句话木马

## Content

1. 域名提供商来自印度的 PUBLIC
2. DNS 域名解析商是美国的一家老牌域名域名注册商 name.cheap
3. 后台系统最常访问的 IP 在香港

## Reference

- [一不小心就把骗子的盗号网站后台getshell了_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1XS4y1c77H/?spm_id_from=333.337.search-card.all.click&vd_source=25509bb582bc4a25d86d871d5cdffca3)
