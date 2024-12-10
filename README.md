# docker-arch-samba

在 arm64v8 和 amd64 alpine 上使用的 samba 构建材料。

[![GitHub Workflow dockerbuild Status](https://github.com/20241204/docker-arch-samba/actions/workflows/actions.yml/badge.svg)](https://github.com/20241204/docker-arch-samba/actions/workflows/actions.yml)![Watchers](https://img.shields.io/github/watchers/20241204/docker-arch-samba) ![Stars](https://img.shields.io/github/stars/20241204/docker-arch-samba) ![Forks](https://img.shields.io/github/forks/20241204/docker-arch-samba) ![Vistors](https://visitor-badge.laobi.icu/badge?page_id=20241204.docker-arch-samba) ![LICENSE](https://img.shields.io/badge/license-CC%20BY--SA%204.0-green.svg)  
<a href="https://star-history.com/#20241204/docker-arch-samba&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=20241204/docker-arch-samba&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=20241204/docker-arch-samba&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=20241204/docker-arch-samba&type=Date" />
  </picture>
</a>

## ghcr.io  
镜像仓库链接：[https://github.com/20241204/docker-arch-samba/pkgs/container/docker-arch-samba](https://github.com/20241204/docker-arch-samba/pkgs/container/docker-arch-samba)  

## 描述
1.为了实现 actions workflow 自动化 docker 构建运行，需要添加 `GITHUB_TOKEN` 环境变量，这个是访问 GitHub API 的令牌，可以在 GitHub 主页，点击个人头像，Settings -> Developer settings -> Personal access tokens -> Tokens (classic) -> Generate new token -> Generate new token (classic) ，设置名字为 GITHUB_TOKEN 接着要配置 环境变量有效时间，勾选环境变量作用域 repo write:packages workflow 和 admin:repo_hook 即可，最后点击Generate token，如图所示
![image](assets/00.jpeg)
![image](assets/01.jpeg)
![image](assets/02.jpeg)
![image](assets/03.jpeg)  

2.赋予 actions[bot] 读/写仓库权限，在仓库中点击 Settings -> Actions -> General -> Workflow Permissions -> Read and write permissions -> save，如图所示
![image](assets/04.jpeg)

3.转到 Actions  

    -> Clean Git Large Files 并且启动 workflow，实现自动化清理 .git 目录大文件记录  
    -> Docker Image Build and Deploy Images to GHCR CI 并且启动 workflow，实现自动化构建镜像并推送云端  
    -> Remove Old Workflow Runs 并且启动 workflow，实现自动化清理 workflow 并保留最后三个  

4.这是包含了 samba 的 docker 构建材料  
5.以下是思路：    
    这是一个 arm64v8 和 amd64 的 alpine samba 构建材料  
    闲暇之余可以通过 arm64v8 设备上传下载文件  
    samba 是个不错的工具  
    配置文件 docker-compose.yml 这个可以自己按照需求修改  
    整个项目不难，看看配置文件，看看脚本，再看看目录结构，肯定就理解了  

    .                                     # 这个是根目录
    ├── .github                           # 这个是github虚拟机项目
    │   └── workflows                     # 这个是工作流文件夹
    │       ├── actions.yml               # 这个是docker构建编译流文件
    │       ├── clean-git-large-files.yml # 这个是清理 .git 大文件流文件
    │       └── remove-old-workflow.yml   # 这个是移除缓存流文件  
    ├── docker-compose-amd64.yml                 # 这个是 docker-compose-amd64.yml 配置文件
    ├── docker-compose-arm64.yml                 # 这个是 docker-compose-arm64.yml 配置文件   
    ├── Dockerfile                               # 这个是 docker 构建文件  
    └── package                                  # 这个是脚本、配置文件所在目录 
        ├── init.sh                              # 这个是构建镜像的时候在容器内执行初始化流程的脚本   
        ├── install.sh                           # 这个是构建镜像的时候在容器内执行部署流程的脚本   
        ├── run_samba                            # 这个是启动 samba 的脚本  
        └── samba                                # 这个是 samba 默认配置目录，也可以按照需求配置  
            ├── smb.conf                         # 这个是 samba 默认配置文件 默认用户名 root 
            └── smbpasswd                        # 这个是 samba 默认密码文件 默认密码 123456   

## 依赖
    arm64 设备
    docker 程序
    docker-compose python程序
    我目前能想到的必要程序就这些吧

## 构建命令
    # clone 项目
    git clone https://github.com/20241204/docker-arch-samba
    # 进入目录
    cd docker-arch-samba
    # 无缓存构建  
    ## arm64v8  
    docker build --no-cache --platform "linux/arm64/v8" -f Dockerfile -t ghcr.io/20241204/docker-arch-samba:latest . ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)   
    ## amd64  
    docker build --no-cache --platform "linux/amd64" -f Dockerfile -t ghcr.io/20241204/docker-arch-samba:latest . ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)  
    # 或者这么构建也可以二选一
    ## arm64
    docker-compose -f docker-compose-arm64.yml build --no-cache ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)
    ## amd64
    docker-compose -f docker-compose-amd64.yml build --no-cache ; docker builder prune -fa ; docker rmi $(docker images -qaf dangling=true)

## 构建完成后 后台启动
    # 自定义修改 docker-compose.yml 
    # 初始化用户名环境变量 USERS 默认 root
    # 初始化密码环境变量 PASSWORD 默认 123456
    ## arm64
    docker-compose -f docker-compose-arm64.yml up -d --force-recreate
    ## amd64
    docker-compose -f docker-compose-amd64.yml up -d --force-recreate
    
    # 也可以查看日志看看有没有问题 ,如果失败了就再重新尝试看看只要最后不报错就好 
    ## arm64
    docker-compose -f docker-compose-arm64.yml logs -f
    ## amd64
    docker-compose -f docker-compose-amd64.yml logs -f
    
## 系统访问
  ### MacOS 访问samba以及支持的协议请参考
  [https://support.apple.com/zh-cn/guide/mac-help/mchlp1140/mac](https://support.apple.com/zh-cn/guide/mac-help/mchlp1140/14.0/mac/14.0)  
  [https://support.apple.com/zh-cn/guide/mac-help/mchlp3015/14.0/mac/14.0](https://support.apple.com/zh-cn/guide/mac-help/mchlp3015/14.0/mac/14.0)
    
  ### windows 打开资源管理器访问，输入密码和用户名即可（默认用户名 root 默认密码 123456） 
    \\IP\sharedir
    
  ### Linux 界面打开资源管理器访问，输入密码和用户名即可（默认用户名 root 默认密码 123456） 
    smb://IP/sharedir
  ### 非 linux windows macos 系统如何访问 samba ？请参考
  [https://www.google.it/search?q=非 linux windows macos 系统如何访问 samba ？](https://www.google.it/search?q=非+linux+windows+macos+系统如何访问+samba)
    
## 想要修改密码怎么办？
    # 进入目录
    cd docker-arch-samba
    # 进入容器
    docker-compose exec alpine-samba-app bash
    # 修改密码 需输入两次 密码不会显示属于正常现象 密码配置文件会保存到 /etc/samba/smbpasswd
    smbpasswd -a $USERS
    
## 感谢
    恩山大佬 liaohcai：https://www.right.com.cn/forum/thread-8233215-1-1.html

## 参考
    分享openwrt的samba4配置文件无视luci界面：https://www.right.com.cn/forum/thread-8233215-1-1.html  
