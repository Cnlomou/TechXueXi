# 前言
来自 (https://github.com/TechXueXi)
官方网站： https://techxuexi.js.org/
仅自研究扩展

#启动
- docker启动
    ``` shell
    docker-compose up -d #后台运行
    ```
    ``` shell
    docker run -v ./xuexi:/xuexi/user -p 16667:80  -e CRONTIME="10 18,0 * * *" -e Pushmode="6" -e ZhuanXiang="True" -e MaxWorkers="2" -d  cnlomou/xuexitech:1.4
    ```