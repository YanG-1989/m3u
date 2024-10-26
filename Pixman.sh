#!/bin/bash
###############################

# @小白直播搭建脚本
# 项目地址：https://pixman.io/
# 最新版本：1.9.6

###############################

# 设置路径
SCRIPT_PATH="$HOME/pixman.sh"  # 定义脚本路径
CONFIG_FILE="$HOME/.pixman"  # 配置文件路径

# 设置默认环境变量
REVERSE_PROXY="dockerpull.com" # 设置反向代理地址
CRON_SCHEDULE="0 12 * * *"  # 默认定时任务时间
PORT="52055"  # 默认端口
MYTVSUPER_TOKEN=""  # myTV 参数
HAMI_SESSION_ID=""  # Hami 参数
HAMI_SERIAL_NO=""  # Hami 参数
HAMI_SESSION_IP=""  # Hami 参数
HTTP_PROXY=""  # 设置代理
HTTPS_PROXY=""  # 设置代理

# 设置颜色变量
RED="\033[1;31m"  # 红
GREEN="\033[1;32m"  # 绿
YELLOW="\033[1;33m"  # 黄
CYAN="\033[1;36m"  # 青
RESET="\033[0m"  # 重置

# echo -e "${CYAN}这是绿色粗体文本。${RESET}"

#############  菜单  #############

# 显示 菜单
show_menu() {
    echo "-------------------"
    echo "  @小白直播搭建工具 "
    echo "   输入 y 快捷启动  "
    echo "-------------------"
    echo "   请选择一个项目： "
    echo "-------------------"
    echo "1)   Pixman 项目   "
    echo "2)  Allinone 项目  "
    echo "~~~~~~~~~~~~~~~~~~~"
    echo "3)  -- 工具箱 --   "
    echo "~~~~~~~~~~~~~~~~~~~"
    echo "4) ~~ 脚本信息 ~~  "
    echo "-------------------"
    echo "0)      退出       "
    echo "     [ Ctrl+C ]    "
    echo "-------------------"

}

# Pixman 菜单
show_pixman_menu() {
    echo "-------------------"
    echo "    Pixman 菜单：  "
    echo "-------------------"
    echo "1) 安装 Pixman 项目"
    echo "2) 修改 Pixman 参数"
    echo "3) 生成 Pixman 订阅"
    echo "4) 转换  myTV  订阅"
    echo "5) 卸载 Pixman 项目"
    echo "-------------------"
    echo "0)   返回主菜单     "
    echo "-------------------"
}

# allinone 菜单
show_allinone_menu() {
    echo "---------------------"
    echo "     Allinone 菜单： "
    echo "---------------------"
    echo "1) 安装 Allinone 项目"
    echo "2) 安装   av3a   助手"
    echo "3) 设置 反向代理 地址 "
    echo "4) 卸载 Allinone 项目"
    echo "---------------------"
    echo "0)    返回主菜单     "
    echo "---------------------"
}

# 工具箱 菜单
show_toolbox_menu() {
    echo "----------------------"
    echo "       工具箱菜单：   "
    echo "----------------------"
    echo "1)  1Panle 面板        "
    echo "2)  [Docker] o11       "
    echo "3)  [Docker] 3X-UI     "
    echo "~~~~~~~~~~~~~~~~~~~~~~"
    echo "5)  Docker 一键清理    "
    echo "----------------------"
    echo "0)     返回主菜单      "
    echo "----------------------"
}

# 1Panel 菜单
show_1panel_menu() {
    echo "-------------------"
    echo "    1Panel 菜单：   "
    echo "-------------------"
    echo "1)   安装 1Panel   "
    echo "2)   卸载 1Panel   "
    echo "3)   设置 1Panel   "
    echo "-------------------"
    echo "0)  返回上级菜单    "
    echo "-------------------"
}

# 3X-UI 菜单
show_3x_ui_menu() {
    echo "-------------------"
    echo "    3X-UI 菜单： "
    echo "-------------------"
    echo "1)   安装 3X-UI    "
    echo "2)   更新 3X-UI    "
    echo "3)   卸载 3X-UI    "
    echo "-------------------"
    echo "0)  返回上级菜单    "
    echo "-------------------"
}

# o11 菜单
show_o11_menu() {
    echo "-------------------"
    echo "     o11 菜单：     "
    echo "-------------------"
    echo "1)    安装 o11     "
    echo "2)    卸载 o11     "
    echo "-------------------"
    echo "0)  返回上级菜单    "
    echo "-------------------"
}

# subs 菜单
show_subs_menu() {
    echo "-------------------"
    echo "   Sub Store 菜单： "
    echo "-------------------"
    echo "1) 安装 Sub Store  "
    echo "2) 卸载 Sub Store  "
    echo "-------------------"
    echo "0)  返回上级菜单    "
    echo "-------------------"
}

#############  Pixman  #############

# 加载 Pixman 参数
load_parameters() {
    if [ -e "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        if docker ps -a --format '{{.Names}}' | grep -q "^pixman$"; then
            check_and_install_jq
            extract_container_parameters
            source "$CONFIG_FILE"
        else
            return 1  
        fi
    fi
}

# 提取 Pixman 参数
extract_container_parameters() {
    container_info=$(docker inspect "pixman")

    PORT=$(echo "$container_info" | jq -r '.[0].HostConfig.PortBindings."5000/tcp"[0].HostPort // empty')

    if [ -z "$PORT" ]; then
        PORT=5000
    fi

    MYTVSUPER_TOKEN=$(echo "$container_info" | jq -r '.[0].Config.Env[] | select(startswith("MYTVSUPER_TOKEN="))' | cut -d= -f2)
    HAMI_SESSION_ID=$(echo "$container_info" | jq -r '.[0].Config.Env[] | select(startswith("HAMI_SESSION_ID="))' | cut -d= -f2)
    HAMI_SERIAL_NO=$(echo "$container_info" | jq -r '.[0].Config.Env[] | select(startswith("HAMI_SERIAL_NO="))' | cut -d= -f2)
    HAMI_SESSION_IP=$(echo "$container_info" | jq -r '.[0].Config.Env[] | select(startswith("HAMI_SESSION_IP="))' | cut -d= -f2)
    HTTP_PROXY=$(echo "$container_info" | jq -r '.[0].Config.Env[] | select(startswith("HTTP_PROXY="))' | cut -d= -f2)
    HTTPS_PROXY=$(echo "$container_info" | jq -r '.[0].Config.Env[] | select(startswith("HTTPS_PROXY="))' | cut -d= -f2)

    echo "PORT=$PORT" > "$CONFIG_FILE"
    echo "MYTVSUPER_TOKEN=$MYTVSUPER_TOKEN" >> "$CONFIG_FILE"
    echo "HAMI_SESSION_ID=$HAMI_SESSION_ID" >> "$CONFIG_FILE"
    echo "HAMI_SERIAL_NO=$HAMI_SERIAL_NO" >> "$CONFIG_FILE"
    echo "HAMI_SESSION_IP=$HAMI_SESSION_IP" >> "$CONFIG_FILE"
    echo "HTTP_PROXY=$HTTP_PROXY" >> "$CONFIG_FILE"
    echo "HTTPS_PROXY=$HTTPS_PROXY" >> "$CONFIG_FILE"
}

# 保存 Pixman 参数
save_parameters() {
    {
        echo "REVERSE_PROXY=$REVERSE_PROXY"
        echo "SCRIPT_PATH=$SCRIPT_PATH"
        [ -n "$PORT" ] && echo "PORT=$PORT"
        [ -n "$CRON_SCHEDULE" ] && echo "CRON_SCHEDULE=$CRON_SCHEDULE"
        [ -n "$MYTVSUPER_TOKEN" ] && echo "MYTVSUPER_TOKEN=$MYTVSUPER_TOKEN"
        [ -n "$HAMI_SESSION_ID" ] && echo "HAMI_SESSION_ID=$HAMI_SESSION_ID"
        [ -n "$HAMI_SERIAL_NO" ] && echo "HAMI_SERIAL_NO=$HAMI_SERIAL_NO"
        [ -n "$HAMI_SESSION_IP" ] && echo "HAMI_SESSION_IP=$HAMI_SESSION_IP"
        [ -n "$HTTP_PROXY" ] && echo "HTTP_PROXY=$HTTP_PROXY"
        [ -n "$HTTPS_PROXY" ] && echo "HTTPS_PROXY=$HTTPS_PROXY"
    } > "$CONFIG_FILE"
}

# 设置 Pixman 参数
set_parameters() {
    local original_port="$PORT"
    local original_token="$MYTVSUPER_TOKEN"
    local original_session_id="$HAMI_SESSION_ID"
    local original_serial_no="$HAMI_SERIAL_NO"
    local original_session_ip="$HAMI_SESSION_IP"
    local original_http_proxy="$HTTP_PROXY"
    local original_https_proxy="$HTTPS_PROXY"

    read -p "请输入反向代理地址 (回车跳过保持当前值: $REVERSE_PROXY): " input_reverse_proxy
    [ -n "$input_reverse_proxy" ] && REVERSE_PROXY="$input_reverse_proxy"

    read -p "请确认脚本路径 (回车跳过保持当前值: $SCRIPT_PATH): " input_path
    [ -n "$input_path" ] && SCRIPT_PATH="$input_path"

    read -p "请输入定时任务时间 (cron格式，回车跳过保持当前值: $CRON_SCHEDULE): " input_cron
    [ -n "$input_cron" ] && CRON_SCHEDULE="$input_cron"

    read -p "请输入端口 (回车跳过保持当前值: $PORT): " input_port
    [ -n "$input_port" ] && PORT="$input_port"

    read -p "请输入 MYTVSUPER_TOKEN (回车跳过保持当前值: $MYTVSUPER_TOKEN): " input_token
    [ -n "$input_token" ] && MYTVSUPER_TOKEN="$input_token"

    read -p "请输入 HAMI_SESSION_ID (回车跳过保持当前值: $HAMI_SESSION_ID): " input_id
    [ -n "$input_id" ] && HAMI_SESSION_ID="$input_id"

    read -p "请输入 HAMI_SERIAL_NO (回车跳过保持当前值: $HAMI_SERIAL_NO): " input_serial
    [ -n "$input_serial" ] && HAMI_SERIAL_NO="$input_serial"

    read -p "请输入 HAMI_SESSION_IP (回车跳过保持当前值: $HAMI_SESSION_IP): " input_ip
    [ -n "$input_ip" ] && HAMI_SESSION_IP="$input_ip"

    read -p "请输入 HTTP_PROXY (回车跳过保持当前值: $HTTP_PROXY): " input_http_proxy
    [ -n "$input_http_proxy" ] && HTTP_PROXY="$input_http_proxy"

    read -p "请输入 HTTPS_PROXY (回车跳过保持当前值: $HTTPS_PROXY): " input_https_proxy
    [ -n "$input_https_proxy" ] && HTTPS_PROXY="$input_https_proxy"

    save_parameters  

    if [[ "$PORT" != "$original_port" || \
          "$MYTVSUPER_TOKEN" != "$original_token" || \
          "$HAMI_SESSION_ID" != "$original_session_id" || \
          "$HAMI_SERIAL_NO" != "$original_serial_no" || \
          "$HAMI_SESSION_IP" != "$original_session_ip" || \
          "$HTTP_PROXY" != "$original_http_proxy" || \
          "$HTTPS_PROXY" != "$original_https_proxy" ]]; then
        echo -e "${CYAN}检测到参数变化，正在卸载旧的 Pixman 容器...${RESET}"
        docker rm -f pixman > /dev/null 2>&1
        check_update
    else
        echo -e "${CYAN}参数未发生变化，无需重启 Pixman 容器${RESET}"
        return 0
    fi
}

# 设置 Pixman 自动更新
set_cron_job() {
    (crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH --auto"; echo "$CRON_SCHEDULE $SCRIPT_PATH --auto") | crontab -
}

# 判断 Pixman 容器
check_update() {
    echo -e "${CYAN}检查更新...${RESET}"

    IMAGE_SOURCE="pixman/pixman:latest"
    PROXY_IMAGE_SOURCE="$REVERSE_PROXY/pixman/pixman:latest"

    if docker ps -a --format '{{.Names}}' | grep -q "^pixman$"; then
        current_image_version=$(docker inspect --format='{{index .Config.Labels "org.opencontainers.image.version"}}' pixman)

        MODE=$(docker inspect --format='{{.HostConfig.NetworkMode}}' pixman)

        if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
            echo -e "${CYAN}尝试使用代理...${RESET}"
            if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
                echo -e "${RED}安装 Pixman 失败，请检查代理或网络连接。${RESET}"
                exit 1
            fi
            IMAGE_SOURCE="$PROXY_IMAGE_SOURCE"
        fi

        latest_image_version=$(docker inspect --format='{{index .Config.Labels "org.opencontainers.image.version"}}' "$IMAGE_SOURCE")

        if [ "$current_image_version" != "$latest_image_version" ]; then
            echo -e "${GREEN}发现新版本 ($latest_image_version)，正在更新...${RESET}"
            docker rm -f pixman > /dev/null 2>&1
            docker rmi -f "$IMAGE_SOURCE" > /dev/null 2>&1
            docker pull "$IMAGE_SOURCE" > /dev/null 2>&1
            start_container "$IMAGE_SOURCE" "$MODE"
        else
            echo -e "${GREEN}当前版本 ($current_image_version)，无需更新...${RESET}"
        fi
    else
        if ! docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^pixman/pixman:latest$"; then
            if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
                echo "尝试使用代理..."
                if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
                    echo "使用代理拉取失败，请检查代理或网络连接。"
                    return 1
                fi
                latest_image_version=$(docker inspect --format='{{index .Config.Labels "org.opencontainers.image.version"}}' "$IMAGE_SOURCE")
                echo -e "${GREEN}目前版本 ($latest_image_version)，正在安装...${RESET}"
                IMAGE_SOURCE="$PROXY_IMAGE_SOURCE"
            fi
        fi
        start_container "$IMAGE_SOURCE"
    fi
}

# 部署 Pixman 容器
start_container() {
    local image_source="$1"
    local mode="$2"
    local port="${PORT:-52055}"

    echo -e "${CYAN}启动 Pixman 容器...${RESET}"

    if [ "$mode" != "bridge" ] && [ "$mode" != "host" ]; then
        echo "请选择 Docker 模式："
        echo "1. Bridge 模式 (默认)"
        echo "2. Host 模式"

        read -p "输入选择 [1/2]: " user_choice
        mode="bridge" 
        [[ "$user_choice" == "2" ]] && mode="host"
    fi

    if [[ "$mode" == "host" ]]; then
        echo "目前使用 host 模式，默认端口: 5000。"
        docker_command="docker run -d --name pixman --restart always --net=host"
    else
        echo "目前使用 bridge 模式，默认端口: $port 。"
        docker_command="docker run -d --name pixman --restart always -p $port:5000"
    fi

    [ -n "$MYTVSUPER_TOKEN" ] && docker_command+=" -e MYTVSUPER_TOKEN=$MYTVSUPER_TOKEN"
    [ -n "$HAMI_SESSION_ID" ] && docker_command+=" -e HAMI_SESSION_ID=$HAMI_SESSION_ID"
    [ -n "$HAMI_SERIAL_NO" ] && docker_command+=" -e HAMI_SERIAL_NO=$HAMI_SERIAL_NO"
    [ -n "$HAMI_SESSION_IP" ] && docker_command+=" -e HAMI_SESSION_IP=$HAMI_SESSION_IP"
    [ -n "$HTTP_PROXY" ] && docker_command+=" -e HTTP_PROXY=$HTTP_PROXY"
    [ -n "$HTTPS_PROXY" ] && docker_command+=" -e HTTPS_PROXY=$HTTPS_PROXY"

    docker_command+=" $image_source"
    eval "$docker_command"

    echo -e "${GREEN}Pixman 容器已启动。${RESET}"
}

# 卸载 Pixman 项目
uninstall_pixman() {
    echo "是否确定要卸载 Pixman 项目？[y/n]"
    read -r -t 10 input
    input=${input:-n}
    
    if [[ "$input" =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}正在卸载 Pixman 项目...${RESET}"
        docker stop pixman > /dev/null 2>&1
        docker rm -f pixman > /dev/null 2>&1
        for image in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'pixman/pixman'); do
            docker rmi "$image" > /dev/null 2>&1
        done
        crontab -l | grep -v "$SCRIPT_PATH"
        # rm -f "$SCRIPT_PATH"
        # rm -f "$CONFIG_FILE"
        # sed -i '/alias y=/d' ~/.bashrc
        echo -e "${RED}Pixman 项目已成功卸载。${RESET}"
    else
        echo -e "${GREEN}取消卸载操作。${RESET}"
    fi
}

# 生成 Pixman 订阅 
live_pixman() {
    local public_ip
    local port
    local container_id
    container_id=$(docker ps -aq -f name=pixman 2>/dev/null)

    if [ -z "$container_id" ]; then
        echo -e "${RED}错误: Pixman 容器不存在。${RESET}"
        return 1
    fi

    MODE=$(docker inspect --format='{{.HostConfig.NetworkMode}}' pixman)

    if [[ "$MODE" == "host" ]]; then
        port=5000
    else
        port=$(docker inspect -f '{{ (index (index .HostConfig.PortBindings "5000/tcp") 0).HostPort }}' pixman 2>/dev/null)
    fi

    if check_if_in_china; then
        public_ip="{路由IP}"
    else
        public_ip=$(curl -s ifconfig.me || echo "{公网IP}")
    fi

    parse_cron_schedule "$CRON_SCHEDULE"
    echo "■ 央视频 YSP :  http://${public_ip}:${port}/ysp.m3u"
    echo "■ 江苏移动魔百盒 TPTV : http://${public_ip}:${port}/tptv.m3u 或 http://${public_ip}:${port}/tptv_proxy.m3u"
    echo "■ 中国移动 iTV : http://${public_ip}:${port}/itv.m3u 或 http://${public_ip}:${port}/itv_proxy.m3u"

    if check_internet_connection; then
        echo "■ YouTube 代理 : http://${public_ip}:${port}/youtube/{VIDEO_ID} （房间号）"
        echo "■ 四季線上 4GTV : http://${public_ip}:${port}/4gtv.m3u"

        if [ -n "$MYTVSUPER_TOKEN" ]; then
            echo "■ MytvSuper : http://${public_ip}:${port}/mytvsuper.m3u"
        fi

        if [ -n "$HAMI_SESSION_ID" ] && [ -n "$HAMI_SERIAL_NO" ] && [ -n "$HAMI_SESSION_IP" ]; then
            echo "■ Hami Video : http://${public_ip}:${port}/hami.m3u"
        fi
    fi
    echo "■ Beesport : http://${public_ip}:${port}/beesport.m3u"
    echo "■ TheTV : http://${public_ip}:${port}/thetv.m3u"
    echo "■ DLHD : http://${public_ip}:${port}/dlhd.m3u"
    echo "---------------------------------------------------------"
    echo "---  Pixman 详细使用说明: https://pixman.io/topics/17  ---"
    echo "---  Pixman.sh 脚本日志: https://pixman.io/topics/142  ---"
    echo "---------------------------------------------------------"

    read -p "按 回车键 返回 主菜单 ..."
}

# 生成 myTV 订阅
Convert_pixman() {
    local public_ip
    local port
    local container_id
    container_id=$(docker ps -aq -f name=pixman 2>/dev/null)

    if [ -z "$container_id" ]; then
        echo -e "${RED}错误: Pixman 容器不存在。${RESET}"
        return 1
    fi

    if [ -n "$MYTVSUPER_TOKEN" ]; then
        if ping -c 1 google.com > /dev/null 2>&1; then
            MODE=$(docker inspect --format='{{.HostConfig.NetworkMode}}' pixman)

            if [[ "$MODE" == "host" ]]; then
                port=5000
            else
                port=$(docker inspect -f '{{ (index (index .HostConfig.PortBindings "5000/tcp") 0).HostPort }}' pixman 2>/dev/null)
            fi

            if check_if_in_china; then
                public_ip="{路由IP}"
            else
                public_ip=$(curl -s ifconfig.me || echo "{公网IP}")
            fi

            echo "生成订阅中..."
            docker exec pixman sh -c 'flask mytvsuper_tivimate'
            echo "---------------------------------------------------------"
            echo "■ MytvSuper-tivimate : http://${public_ip}:${port}/mytvsuper-tivimate.m3u"

            (crontab -l; echo "0 */12 * * * /usr/bin/docker exec pixman sh -c 'flask mytvsuper_tivimate'") | crontab -

            echo "■ 定时任务已设置，每 12 小时自动更新 M3U。"
        else
            echo -e "${RED}请查看网络环境，目前已禁用 myTV 服务。${RESET}"
            return 1
        fi
    else
        echo -e "${CYAN}MYTVSUPER_TOKEN 参数不能为空，无法生成订阅。${RESET}"
        return 1
    fi

    echo "---------------------------------------------------------"
    echo "---  Pixman 详细使用说明: https://pixman.io/topics/17  ---"
    echo "---  Pixman.sh 脚本日志: https://pixman.io/topics/142  ---"
    echo "---------------------------------------------------------"

    read -p "按 回车键 返回 主菜单 ..."
}

#############  Allinone #############

 # 安装 Allinone
install_allinone() {

    if docker ps -a --format '{{.Names}}' | grep -q "^allinone$"; then
        echo "检测到已存在的 Allinone 容器，将进行手动更新..."
        docker stop allinone > /dev/null 2>&1
        docker rm allinone > /dev/null 2>&1
        for image in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'youshandefeiyang/allinone'); do
            docker rmi "$image" > /dev/null 2>&1
        done
        echo -e "${CYAN}已停止并删除旧的 Allinone 项目。${RESET}"
    fi

    echo "请选择部署方式（默认: 1):"
    echo "1) 使用 host 网络模式"
    echo "2) 使用 bridge 网络模式"
    
    read -rp "输入选项 (1 或 2): " option
    option=${option:-1} 

    local public_ip
    local PORT=35455

    if check_if_in_china; then
        public_ip="{路由IP}"
    else
        public_ip=$(curl -s ifconfig.me || echo "{公网IP}")
    fi

    IMAGE_SOURCE="youshandefeiyang/allinone"
    PROXY_IMAGE_SOURCE="$REVERSE_PROXY/youshandefeiyang/allinone"

    if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
        echo -e "${CYAN}尝试使用代理拉取镜像...${RESET}"
        if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
            echo -e "${RED}安装 Allinone 失败，请检查代理或网络连接。${RESET}"
            exit 1
        fi
        IMAGE_SOURCE="$PROXY_IMAGE_SOURCE"
    fi

    case $option in
        1)
            echo "正在使用 host 网络模式安装 Allinone..."
            port=$PORT
            docker run -d --restart unless-stopped --net=host --privileged=true --name allinone "$IMAGE_SOURCE"
            echo -e "${GREEN}Allinone 安装完成。${RESET}"

            install_watchtower "allinone"
            
            echo "---------------------------------------------------------"
            echo "■ 订阅地址："
            if check_if_in_china; then
                echo "■ TV 集合 : http://$public_ip:$port/tv.m3u"
                echo "■ TPTV : http://$public_ip:$port/tptv.m3u"
            fi
            ;;

        2)
            echo "正在使用 bridge 网络模式安装 Allinone..."
            
            read -rp "请输入要映射的端口 (默认: $PORT): " port
            port=${port:-$PORT} 

            if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1024 ] || [ "$port" -gt 65535 ]; then
                echo "无效端口。请使用 1024 到 65535 之间的数字。"
                return 1
            fi

            docker run -d --restart unless-stopped --net=bridge --privileged=true -p "$port:35455" --name allinone "$IMAGE_SOURCE"

            echo -e "${GREEN}Allinone 安装完成。${RESET}"

            install_watchtower "allinone"

            echo "---------------------------------------------------------"
            echo "■ 订阅地址："
            if check_if_in_china; then
                echo "■ TV 集合 : http://$public_ip:$port/tv.m3u"
                echo "■ TPTV : http://$public_ip:$port/tptv.m3u"
            fi
            ;;

        *)
            echo -e "${CYAN}无效选项，请选择 1 或 2。${RESET}"
            return 1
            ;;
    esac

    live_allinone "$public_ip" "$port"
}

# 生成 Allinone 订阅
live_allinone() {
    local public_ip="$1"
    local PORT="$2"

    echo "■ YY轮播 : http://${public_ip}:${PORT}/yylunbo.m3u"
    echo "■ BiliBili生活 : http://${public_ip}:${PORT}/bililive.m3u"
    echo "■ 虎牙一起看 : http://${public_ip}:${PORT}/huyayqk.m3u"
    echo "■ 斗鱼一起看 : http://${public_ip}:${PORT}/douyuyqk.m3u"
    echo "---------------------------------------------------------"
    echo "■ 代理地址："
    echo "■ BiliBili 代理 : http://${public_ip}:${PORT}/bilibili/{VIDEO_ID}"
    echo "■ 虎牙 代理 : http://${public_ip}:${PORT}/huya/{VIDEO_ID}"
    echo "■ 斗鱼 代理 : http://${public_ip}:${PORT}/douyu/{VIDEO_ID}"
    echo "■ YY 代理 : http://${public_ip}:${PORT}/yy/{VIDEO_ID}"
    echo "■ 抖音 代理 : http://${public_ip}:${PORT}/douyin/{VIDEO_ID}"
    echo "■ YouTube 代理 : http://${public_ip}:${PORT}/youtube/{VIDEO_ID}"
    echo "---------------------------------------------------------"
    echo "---    allinone 详细使用说明: https://yycx.eu.org      ---"
    echo "---  Pixman.sh 脚本日志: https://pixman.io/topics/142  ---"
    echo "---------------------------------------------------------"

    read -p "按 回车键 返回 主菜单 ..."
}

# 设置反向代理参数
proxy_allinone() {
    read -p "请输入反向代理地址 (回车跳过保持当前值: $REVERSE_PROXY): " input_reverse_proxy
    [ -n "$input_reverse_proxy" ] && REVERSE_PROXY="$input_reverse_proxy"

    echo "反向代理地址已更新为: $REVERSE_PROXY"

    save_parameters
}

# 卸载 Allinone 
uninstall_allinone() {
    read -p "您确定要卸载 Allinone 及删除所有相关文件吗？(y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "卸载操作已取消。"
        return
    fi
    if docker ps -a | grep -q allinone; then
        docker stop allinone > /dev/null 2>&1
        docker rm allinone > /dev/null 2>&1
    fi
    if docker ps -a | grep -q av3a-assistant; then
        docker stop av3a-assistant > /dev/null 2>&1
        docker rm av3a-assistant > /dev/null 2>&1
    fi
    if [ -d "/av3a" ]; then
        rm -rf /av3a
    fi

    for image in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'youshandefeiyang/allinone'); do
        docker rmi "$image" > /dev/null 2>&1
    done

    for image in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'av3a-assistant'); do
        docker rmi "$image" > /dev/null 2>&1
    done

    echo -e "${GREEN}Allinone 及其所有相关文件已完全卸载。${RESET}"
}

# 检查 Docker Compose 是否安装
install_Docker_Compose() {
    if ! command -v docker-compose &> /dev/null; then
        echo "Docker Compose 未安装，正在尝试安装..."
        sudo curl -L "https://ghproxy.cc/https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose

        if ! command -v docker-compose &> /dev/null; then
            echo "Docker Compose 安装失败，请手动安装。"
            echo "参考资料:https://blog.csdn.net/Jimu2018/article/details/138325666"
            exit 1
        fi
        
        echo -e "${GREEN}Docker Compose 安装完成。${RESET}"
    else
        echo -e "${GREEN}Docker Compose 已安装。${RESET}"
    fi
}

# 安装 av3a
install_av3a() {
    if ! check_if_in_china; then
        echo -e "${RED}境外已禁止开启 av3a 服务。${RESET}"
        return
    fi

    local public_ip="{路由IP}"
    local PORT=35455

    echo "若安装 av3a 助手，将固定端口，并删除 Allinone 部署，且 Docker 空间建议预留 3G 以上。"
    read -p "是否继续安装 (y/n，默认 n): " CONFIRM_INSTALL
    CONFIRM_INSTALL=${CONFIRM_INSTALL:-n}
    if [[ "$CONFIRM_INSTALL" != "y" ]]; then
        echo "安装已被终止。"
        return
    fi

    if docker ps -a --format '{{.Names}}' | grep -q "av3a-assistant"; then
        echo "av3a-assistant 容器已安装，跳过安装步骤。"
        return
    fi

    install_Docker_Compose

    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64"  || "$ARCH" == "amd64" ]]; then
        echo "系统架构: amd64/x86_64"
        INSTALL_PATH="/av3a"
        generate_docker_compose "amd64" "$INSTALL_PATH"
    elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
        echo "系统架构: arm64/aarch64"
        INSTALL_PATH="/av3a"
        generate_docker_compose "arm64" "$INSTALL_PATH"
    else
        echo "不支持的系统架构: $ARCH，av3a 安装失败..."
        return
    fi

    if docker ps -a --format '{{.Names}}' | grep -q '^allinone$'; then
        echo "检测到已存在的 allinone 容器，正在停止并删除..."
        docker stop allinone > /dev/null 2>&1
        docker rm allinone > /dev/null 2>&1
    fi

    if generate_docker_compose "$ARCH" "$INSTALL_PATH"; then
        cd "$INSTALL_PATH"
        if docker-compose up -d; then
            echo "---------------------------------------------------------"
            echo -e "${GREEN}Allinone 和 av3a-assistant 均已安装${RESET}"
            echo "---------------------------------------------------------"
            echo "■ 订阅地址："
            echo "■ TV 集合 : http://$public_ip:35442/tv.m3u  (av3a)" 
            echo "■ TV 集合 : http://$public_ip:35455/tv.m3u  (原版)"
            echo "■ TPTV : http://$public_ip:35455/tptv.m3u"
            live_allinone "$public_ip" "$PORT"
        else
            echo "启动 Docker 容器失败。"
            exit 1
        fi
    else
        echo "生成 Docker Compose 文件失败，后续操作将被终止。"
        exit 1
    fi
}

# 生成 Docker Compose 文件
generate_docker_compose() { 
    local arch=$1 
    local install_path=$2 

    mkdir -p "$install_path" || { echo "无法创建目录 $install_path"; return 1; } 

    if [[ "$arch" == "x86_64" || "$arch" == "amd64" ]]; then 
        cat <<EOF > "$install_path/docker-compose.yml"
services: 
  av3a-assistant: 
    image: ${REVERSE_PROXY}/youshandefeiyang/av3a-assistant:amd64 
    container_name: av3a-assistant 
    privileged: true 
    restart: unless-stopped 
    ports: 
      - "35442:35442" 
    networks: 
      - my-network 

  allinone: 
    image: ${REVERSE_PROXY}/youshandefeiyang/allinone 
    container_name: allinone 
    privileged: true 
    restart: unless-stopped 
    ports: 
      - "35455:35455" 
    networks: 
      - my-network 

networks: 
  my-network: 
    driver: bridge
EOF
    elif [[ "$arch" == "aarch64" || "$arch" == "arm64" ]]; then 
        cat <<EOF > "$install_path/docker-compose.yml"
services: 
  av3a-assistant: 
    image: ${REVERSE_PROXY}/youshandefeiyang/av3a-assistant:arm64 
    container_name: av3a-assistant 
    privileged: true 
    restart: unless-stopped 
    ports: 
      - "35442:35442" 
    networks: 
      - my-network 

  allinone: 
    image: ${REVERSE_PROXY}/youshandefeiyang/allinone 
    container_name: allinone 
    privileged: true 
    restart: unless-stopped 
    ports: 
      - "35455:35455" 
    networks: 
      - my-network 

networks: 
  my-network: 
    driver: bridge
EOF
    else 
        echo "不支持的系统架构: $arch" 
        return 1 
    fi 
}

#############  watchtower  #############

# 设置 watchtower 任务
install_watchtower() {
    local name=$1

    if [ "$(docker ps -q -f name=watchtower)" ]; then
        existing_args=$(docker inspect --format '{{.Args}}' watchtower)
        monitored_containers=$(echo "$existing_args" | grep -oP '(\w+)' | tr '\n' ' ')

        if echo "$monitored_containers" | grep -qw "$name"; then
            echo "---------------------------------------------------------"
            echo -e "${CYAN}■ 服务器将于每天凌晨五点，进行检测更新。${RESET}"
            return
        fi

        monitored_containers+="$name"

        docker stop watchtower > /dev/null 2>&1
        docker rm watchtower > /dev/null 2>&1
    else
        monitored_containers="$name"
    fi

    echo "正在安装或配置 Watchtower 并监控 $name 镜像更新..."

    IMAGE_SOURCE="containrrr/watchtower"
    PROXY_IMAGE_SOURCE="$REVERSE_PROXY/containrrr/watchtower"

    if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
        echo -e "${CYAN}尝试使用代理拉取镜像...${RESET}"
        if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
            echo -e "${RED}安装 watchtower 失败，请检查代理或网络连接。${RESET}"
            return
        fi
        IMAGE_SOURCE="$PROXY_IMAGE_SOURCE"
    fi 

    docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock "$IMAGE_SOURCE" $monitored_containers -c --schedule "0 5 * * *"
    echo "---------------------------------------------------------"
    echo -e "${CYAN}■ 服务器将于每天凌晨五点，进行检测更新。${RESET}"
}

# 卸载 Watchtower 监控指定容器
uninstall_watchtower() {
    local name=$1

    if [ "$(docker ps -q -f name=watchtower)" ]; then
        echo "正在检查 Watchtower 监控的容器..."

        existing_args=$(docker inspect --format '{{.Args}}' watchtower)
        monitored_containers=$(echo "$existing_args" | grep -oP '(\w+)' | tr '\n' ' ')

        if echo "$monitored_containers" | grep -qw "$name"; then

            monitored_containers=$(echo "$monitored_containers" | sed "s/\b$name\b//g")
            
            if [ -z "$monitored_containers" ]; then
                echo "没有其他监控的容器，正在停止并删除 Watchtower..."
                docker stop watchtower > /dev/null 2>&1
                docker rm watchtower > /dev/null 2>&1
                
                for image in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'containrrr/watchtower'); do
                    docker rmi "$image" > /dev/null 2>&1
                done
                
                echo "Watchtower 已成功卸载。"
            else
                docker stop watchtower > /dev/null 2>&1
                docker rm watchtower > /dev/null 2>&1
                echo "正在更新 Watchtower，仅监控剩余容器..."
                
                IMAGE_SOURCE="containrrr/watchtower"
                PROXY_IMAGE_SOURCE="$REVERSE_PROXY/containrrr/watchtower"

                if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
                    echo -e "${CYAN}尝试使用代理拉取镜像...${RESET}"
                    if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
                        echo -e "${RED}安装 watchtower 失败，请检查代理或网络连接。${RESET}"
                        return
                    fi
                    IMAGE_SOURCE="$PROXY_IMAGE_SOURCE"
                fi 

                docker run -d --name watchtower --restart unless-stopped -v /var/run/docker.sock:/var/run/docker.sock "$IMAGE_SOURCE" $monitored_containers -c --schedule "0 5 * * *"
                echo "· "$name" 容器已从监控中删除。"
            fi
        else
            echo "容器 $name 未被 Watchtower 监控。"
        fi
    else
        echo "Watchtower 当前未安装。"
    fi
}

#############  3X-UI  #############

# 安装 3X-UI 
install_3x_ui() {
    echo "请选择部署方式："
    echo "1) 使用 host 网络模式 (添加节点方便)"
    echo "2) 使用 bridge 网络模式 (添加节点,需映射端口)"
    echo "3) 使用 sh 脚本 直接安装 (推荐)"
    read -rp "输入选项 (1-3): " option

    if check_if_in_china; then
        local public_ip="{路由IP}"
    else
        local public_ip=$(curl -s ifconfig.me || echo "{公网IP}")
    fi

    case $option in
        1)
            echo "正在使用 host 网络模式安装 3X-UI 面板..."
            docker run -d \
                -e XRAY_VMESS_AEAD_FORCED=false \
                -v "$PWD/db/:/etc/x-ui/" \
                -v "$PWD/cert/:/root/cert/" \
                --network=host \
                --restart=unless-stopped \
                --name 3x-ui \
                ghcr.io/mhsanaei/3x-ui:latest

            echo -e "${GREEN}3X-UI 安装完成。${RESET}"
            echo "访问信息："
            echo "URL: http://$public_ip:2053"
            ;;

        2)
            echo "正在使用 bridge 网络模式安装 3X-UI 面板..."
            local default_port=17878
            
            read -rp "请输入要映射的端口 (默认: $default_port): " port
            port=${port:-$default_port} 

            if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1024 ] || [ "$port" -gt 65535 ]; then
                echo "无效端口。请使用 1024 到 65535 之间的数字。"
                return 1
            fi

            local node_port1=$(generate_random_port)
            local node_port2=$(generate_random_port)
            local node_port3=$(generate_random_port)

            docker run -d \
                -e XRAY_VMESS_AEAD_FORCED=false \
                -p $port:2053 \
                -p $node_port1:$node_port1 \
                -p $node_port2:$node_port2 \
                -v "$PWD/db/:/etc/x-ui/" \
                -v "$PWD/cert/:/root/cert/" \
                --restart=unless-stopped \
                --name 3x-ui \
                ghcr.io/mhsanaei/3x-ui:latest

            echo -e "${GREEN}3X-UI 安装完成。${RESET}"
            echo "访问信息："
            echo "URL: http://$public_ip:$port"
            echo "随机生成两个节点端口，后续自行添加。"
            echo "节点端口: $node_port1"
            echo "节点端口: $node_port2"
            echo "节点端口: $node_port3"
            ;;
        3)
            bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)

            echo -e "${GREEN}3X-UI 安装完成。${RESET}"
            echo "访问信息："
            echo "输入 x-ui 进行修改设置"
            echo "URL: http://$public_ip:2053"
            ;;
        *)  echo "无效的选项，请输入 0-3。" ;;
    esac

    echo "------------------"
    echo "默认用户名: admin"
    echo "默认密码: admin"
    echo "------------------"
    echo "请立即更改默认密码！"
    echo "------------------"
    echo "GIthub: https://github.com/MHSanaei/3x-ui"
    echo "------------------"
    read -p "按 回车键 返回 主菜单 ..."
}

# 更新 3X-UI 
update_3x_ui() {
    echo "正在更新 3X-UI 面板至最新版本..."
    if docker ps -a | grep -q 3x-ui; then
        docker stop 3x-ui > /dev/null 2>&1
        docker rm 3x-ui > /dev/null 2>&1
        install_3x_ui
        echo "3X-UI 面板已更新至最新版本。"
    else
        echo "错误：未找到 3x-ui 容器。请先安装 3X-UI。"
        return 1
    fi
}

# 卸载 3X-UI 
uninstall_3x_ui() {
    read -p "您确定要卸载 3X-UI 面板吗？(y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "卸载操作已取消。"
        return
    fi
    if docker ps -a | grep -q 3x-ui; then
        docker stop 3x-ui > /dev/null 2>&1
        docker rm 3x-ui > /dev/null 2>&1
    fi
    if [ -d "$PWD/db" ]; then
        rm -rf "$PWD/db"
    fi
    for image in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'mhsanaei/3x-ui'); do
        docker rmi "$image" > /dev/null 2>&1
    done

    echo -e "${GREEN}3X-UI 卸载完成。${RESET}"
}

#############  o11  #############

# 安装 o11
install_o11() {
    echo "正在安装 o11 面板..."
    local port=$(generate_random_port)

    if check_if_in_china; then
        local public_ip="{路由IP}"
    else
        local public_ip=$(curl -s ifconfig.me || echo "{公网IP}")
    fi

    docker run -d --restart=always -p $port:1234 --name o11 wechatofficial/o11:latest

    echo -e "${GREEN}o11 安装完成。${RESET}"
    echo "访问信息："
    echo "URL: http://$public_ip:$port"
    echo "小白教程: https://pixman.io/topics/118"
    echo "请根据 o11 的文档进行配置和管理。"
    read -p "按 回车键 返回 主菜单 ..."
}

# 卸载 o11 
uninstall_o11() {
    read -p "您确定要卸载 o11 面板吗？(y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "卸载操作已取消。"
        return
    fi
    if docker ps -a | grep -q o11; then
        docker stop o11 > /dev/null 2>&1
        docker rm o11 > /dev/null 2>&1
    fi
    for image in $(docker images --format '{{.Repository}}:{{.Tag}}' | grep 'wechatofficial/o11'); do
        docker rmi "$image" > /dev/null 2>&1
    done
    echo -e "${GREEN}o11 卸载完成。${RESET}"
}

#############  1Panel  #############

# 安装 1Panel
install_1panel() {
    echo "正在安装 1Panel 面板..."
    curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sudo bash quick_start.sh
    echo "GIthub: https://github.com/1Panel-dev/1Panel"
    echo -e "${GREEN}1Panel 安装完成。${RESET}"
}

# 设置 1Panel
set_1panel() {
    1pctl user-info
    1pctl update password
}

# 卸载 1Panel
uninstall_1panel() {
    read -p "您确定要卸载 1Panel 吗？(y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "卸载操作已取消。"
        return
    fi
    if command -v 1pctl > /dev/null 2>&1; then
        1pctl uninstall
    fi
    echo -e "${GREEN}1Panel 卸载完成。${RESET}"
}

#############  辅助函数  #############

# 检查 网络 是否支持外网
check_internet_connection() {
    if curl -s --max-time 8 google.com > /dev/null; then
        return 0  # 能连接外网
    else
        return 1  # 不能连接外网
    fi
}

# 检查 IP 归属地
check_if_in_china() {
    local sources=(
        "https://myip.ipip.net"
        "https://ipinfo.io/country"
        "http://ip-api.com/json/"
    )
    
    for source in "${sources[@]}"; do
        response=$(curl -s "$source")
        if echo "$response" | grep -qiE "中国|China|CN"; then
            return 0 
        fi
    done
    
    return 1
}

# 检查 Docker 是否安装
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${CYAN}Docker 未安装，正在进行安装...${RESET}"
        install_docker
    else
        echo -e "${GREEN}Docker 已安装。${RESET}"
    fi
}

# 选择 Docker 版本 
install_docker() {
    OS=$(lsb_release -is 2>/dev/null || cat /etc/os-release | grep '^ID=' | cut -d= -f2 | tr -d '"')
    ARCH=$(uname -m)

    case "$OS" in
        Ubuntu)
            echo "检测到系统为 Ubuntu，正在安装 Docker..."
            sudo apt-get update
            sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt-get update
            sudo apt-get install -y docker-ce
            ;;
        Debian|Armbian)
            echo "检测到系统为 Debian 或 Armbian，正在安装 Docker..."
            sudo apt-get update
            sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
            curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
            sudo apt-get update
            sudo apt-get install -y docker-ce
            ;;
        centos|rhel|fedora)
            echo "检测到系统为 CentOS，正在安装 Docker..."
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            sudo yum install -y docker-ce docker-ce-cli containerd.io
            sudo systemctl start docker
            sudo systemctl enable docker
            ;;
        openwrt|lede)
            echo "检测到系统为 OpenWRT/LEDE，正在安装 Docker..."
            opkg update
            opkg install dockerd docker-compose luci-app-dockerman
            /etc/init.d/dockerd start
            /etc/init.d/dockerd enable
            ;;
        *)
            echo "不支持的操作系统: $OS"
            exit 1
            ;;
    esac

    # 如果不是 OpenWRT/LEDE，则启动和启用 Docker
    if [[ "$OS" != "openwrt" && "$OS" != "lede" ]]; then
        sudo systemctl start docker
        sudo systemctl enable docker
    fi

    echo -e "${GREEN}Docker 安装完成。${RESET}"
}

# 检查jq 工具 是否安装
check_and_install_jq() {
    if ! command -v jq &> /dev/null; then
        if check_if_in_china; then
            sudo apt-get update && sudo apt-get install -y jq --allow-releaseinfo-change
        elif command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y jq
        elif command -v yum &> /dev/null; then
            sudo yum install -y jq
        elif command -v apk &> /dev/null; then
            sudo apk add --no-cache jq
        elif command -v opkg &> /dev/null; then  # OpenWrt, Entware 环境
            opkg update && opkg install jq
        else
            return 1  # jq 安装失败
        fi
    else
        return 0  # jq 已安装
    fi
}

# 清理 Docker 工具
cleanup_docker() {
    echo -e "\n🚨 警告：此操作将删除所有已停止的容器、未使用的镜像和卷。"
    read -p "你确认要继续吗？(y/n，默认n): " confirm
    confirm=${confirm:-n}

    if [[ "$confirm" != "y" ]]; then
        echo -e "清理已取消。\n"
        return
    fi

    docker system prune -a --volumes -f

    echo -e "🎉 清理完成。"
    read -p "按 回车键 返回 主菜单 ..."
}

# 转换 Cron 表达式
parse_cron_schedule() {
    local schedule="$1"
    local minute=$(echo "$schedule" | cut -d' ' -f1)
    local hour=$(echo "$schedule" | cut -d' ' -f2)
    local hour_list=()
    local minute_desc=""

    if [[ "$minute" == "0" ]]; then
        minute_desc="整点"
    else
        minute_desc=" ${minute} 分"
    fi

    if [[ "$hour" == "*" ]]; then
        hour_list+=("每小时")
    elif [[ "$hour" == */* ]]; then
        local interval=$(echo "$hour" | cut -d'/' -f2)
        hour_list+=("每 ${interval} 小时")
    else
        IFS=',' read -r -a hours <<< "$hour"
        for h in "${hours[@]}"; do
            if [[ "$h" =~ ^[0-9]+$ ]]; then
                hour_list+=("每天 ${h} 点")
            fi
        done
    fi

    if [[ ${#hour_list[@]} -gt 0 ]]; then
        echo "---------------------------------------------------------"
        echo -e "${CYAN}■ 服务器将于${hour_list[*]}的${minute_desc}，进行检测更新。${RESET}"
        echo "---------------------------------------------------------"
    fi
}

# 生成随机端口
generate_random_port() {
    local port
    while :; do
        port=$(shuf -i 20000-65535 -n 1)
        ss -tuln | grep -q :$port || { echo "$port"; break; }
    done
}

# 更新 SH 脚本
download_pixman() {
    REMOTE_VERSION=$(curl -s "https://yang-1989.eu.org/pixman_version.txt")

    if [ $? -ne 0 ]; then
        echo -e "${RED}无法检测版本，请检查网络连接。${RESET}"
        return
    fi

    if [ -f "$SCRIPT_PATH" ]; then
        LOCAL_VERSION=$(grep -oP '(?<=^# 最新版本：).*' "$SCRIPT_PATH")
    else
        LOCAL_VERSION="" 
    fi

    if [ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]; then
        echo "正在下载最新版本的 Pixman 脚本..."
        curl -o "$SCRIPT_PATH" "https://yang-1989.eu.org/pixman.sh"
        chmod +x "$SCRIPT_PATH"
        echo -e "${GREEN}最新 $REMOTE_VERSION 版本下载已完成。${RESET}"
        # echo "设置 'y' 为快捷启动命令..."
        if [ ! -f ~/.bashrc ]; then
            touch ~/.bashrc
        fi
        if ! grep -q "alias y=" ~/.bashrc; then
            echo "alias y='bash \"$SCRIPT_PATH\" --from-y'" >> ~/.bashrc
            source ~/.bashrc
        fi
    fi
}

# 脚本信息
script_log() {
    echo "------------------------------------------------"
    echo "Pixman 懒人脚本"
    echo "项目地址: https://pixman.io/"
    echo "脚本日志: https://pixman.io/topics/142"
    echo "作者: YanG"
    echo "当前版本号: $(grep -oP '(?<=^# 最新版本：).*' "$SCRIPT_PATH")"
    echo "最后更新时间: 2024.10.24"
    echo "更新内容: 优化 CN 判断，修复 Allinone 部署 BUG。计划 增加 Sub Store 部署，独立 watchtower 设置"
    echo "------------------------------------------------"
    read -p "按 回车键 返回 主菜单 ..."
}

#############  主程序逻辑  #############

load_parameters  # 加载配置参数
download_pixman  # 检查脚本更新


# 检查是否启动定时任务
if [ "$1" == "--auto" ]; then
    echo "定时任务进行中..."
    check_update
    exit 0
fi

# 主循环
while true; do
    show_menu
    read -p "请选择操作: " choice
    case "$choice" in
        1)  # 显示 pixman 菜单
            while true; do
                show_pixman_menu
                read -p "请输入选项 (0-5): " pixman_choice
                case "$pixman_choice" in
                    1) 
                        check_docker
                        check_update
                        set_cron_job
                        live_pixman
                        ;;
                    2) 
                        set_parameters
                        set_cron_job
                        live_pixman
                        ;;
                    3) 
                        live_pixman
                        ;;
                    4) 
                        Convert_pixman
                        ;;
                    5) 
                        uninstall_pixman
                        ;;
                    0) 
                        echo "返回主菜单。"
                        break 
                        ;;
                    *) 
                        echo "无效的选项，请输入 0-5。" 
                        ;;
                esac
            done
            ;;
        2)  # 显示 allinone 菜单
            while true; do
                show_allinone_menu
                read -p "请输入选项 (0-4): " allinone_choice
                case "$allinone_choice" in
                    1) check_docker ; install_allinone ;;
                    2) check_docker ; install_av3a ;;
                    3) proxy_allinone ;;
                    4) uninstall_allinone ;;
                    0) echo "返回主菜单。" ; break ;;
                    *) echo "无效的选项，请输入 0-4。" ;;
                esac
            done
            ;;
        3)  # 工具箱
            while true; do
                show_toolbox_menu
                read -p "请输入选项 (0-4): " toolbox_choice
                case "$toolbox_choice" in
                    1)  # 1Panel 相关操作
                        while true; do
                            show_1panel_menu
                            read -p "请输入选项 (0-3): " panel_choice
                            case "$panel_choice" in
                                1) install_1panel ;;
                                2) uninstall_1panel ;;
                                3) set_1panel ;;
                                0) echo "返回上级菜单。" ; break ;;
                                *) echo "无效的选项，请输入 0-3。" ;;
                            esac
                        done
                        ;;
                    2)  # o11 相关操作
                        while true; do
                            show_o11_menu
                            read -p "请输入选项 (0-2): " o_choice
                            case "$o_choice" in
                                1) check_docker ; install_o11 ;;
                                2) uninstall_o11 ;;
                                0) echo "返回上级菜单。" ; break ;;
                                *) echo "无效的选项，请输入 0-2。" ;;
                            esac
                        done
                        ;;
                    3)  # 3X-UI 相关操作
                        while true; do
                            show_3x_ui_menu
                            read -p "请输入选项 (0-3): " ui_choice
                            case "$ui_choice" in
                                1) check_docker ; install_3x_ui ;;
                                2) update_3x_ui ;;
                                3) uninstall_3x_ui ;;
                                0) echo "返回上级菜单。" ; break ;;
                                *) echo "无效的选项，请输入 0-3。" ;;
                            esac
                        done
                        ;;
                    4)  cleanup_docker ;;
                    0) echo "返回主菜单。" ; break ;;
                    *) echo "无效的选项，请输入 0-3。" ;;
                esac
            done
            ;;
        4) script_log ;;
        0) echo "退出脚本。" ; exit 0 ;;
        *) echo "无效的选项，请输入 0-4。" ;;
    esac
done