#!/bin/bash
###############################
# 名称: NoobIPTV (IPTV 项目相关脚本集合 @小白神器) 
# 作者: YanG-1989
# 项目地址：https://github.com/YanG-1989
# 最新版本：2.0.6
###############################

# 设置路径
SCRIPT_PATH="$HOME/NoobIPTV.sh"  # 定义脚本路径
CONFIG_FILE="$HOME/.NoobIPTV"  # 配置文件路径

# 设置默认环境变量
REVERSE_PROXY="docker.zhai.cm" # 设置反向代理地址
CRON_SCHEDULE="0 5 * * *"  # 默认定时任务时间
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

# echo -e "${GREEN}这是绿色粗体文本。${RESET}"

#############  菜单  #############

# 显示 菜单
show_menu() {
    echo "-------------------"
    echo "  NoobIPTV 工具盒子 "
    echo "   输入 y 快捷启动  "
    echo "-------------------"
    echo "   请选择一个项目： "
    echo "-------------------"
    echo "1)  Pixman 项目    "
    echo "2)  Fourgtv 项目   "
    echo "3)  Doubebly 项目  "
    echo "~~~~~~~~~~~~~~~~~~~"
    echo "4) Docker 更新管理  "
    echo "~~~~~~~~~~~~~~~~~~~"
    echo "5)  -- 工具箱 --   "
    echo "~~~~~~~~~~~~~~~~~~~"
    echo "6) ~~ 脚本信息 ~~  "
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
    echo "2) 设置 Pixman 参数"
    echo "3) 生成 Pixman 订阅"
    echo "4) 转换  myTV  订阅"
    echo "5) 卸载 Pixman 项目"
    echo "-------------------"
    echo "0)   返回主菜单     "
    echo "-------------------"
}

# Fourgtv 菜单
show_fourgtv_menu() {
    echo "---------------------"
    echo "     Fourgtv 菜单： "
    echo "---------------------"
    echo "1) 安装 Fourgtv 项目 "
    echo "2) 卸载 Fourgtv 项目 "
    echo "3) 设置 反向代理 地址 "
    echo "---------------------"
    echo "0)    返回主菜单     "
    echo "---------------------"
}

# Doubebly  菜单
show_doubebly_menu() {
    echo "---------------------"
    echo "    Doubebly  菜单： "
    echo "---------------------"
    echo "1) 安装 Doubebly 项目"
    echo "2) 卸载 Doubebly 项目"
    echo "3) 设置 反向代理  地址"
    echo "---------------------"
    echo "0)    返回主菜单     "
    echo "---------------------"
}

# Watchtower 菜单
show_watchtower_menu() {
    echo "----------------------"
    echo "    Watchtower 菜单：  "
    echo "----------------------"
    echo "1) 一键更新 Docker 项目"
    echo "2) 管理 Docker 项目更新"
    echo "3) 一键清理 Docker 垃圾"
    echo "----------------------"
    echo "0)    返回主菜单       "
    echo "----------------------"
}

# 工具箱 菜单
show_toolbox_menu() {
    echo "---------------------"
    echo "      工具箱菜单：    "
    echo "---------------------"
    echo "1) [233boy] Sing-box "
    echo "2) [Docker] 1Panel   "
    echo "3) [Docker] o11      "
    echo "4) [Docker] 3X-UI    "
    echo "5) [Docker] Sub Store"
    echo "6) [Jimmy ] Alice DNS"
    echo "---------------------"
    echo "0)    返回主菜单      "
    echo "---------------------"
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
reload_configuration() {
    if docker ps -a --format '{{.Names}}' | grep -q "pixman"; then
        check_and_install_jq
        check_and_install_grep
        extract_container_parameters
        source "$CONFIG_FILE"
    else
        return 1
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

    read -p "请输入反向代理地址 (回车跳过保持当前值: $REVERSE_PROXY, 输入null清空): " input_reverse_proxy
    if [ -n "$input_reverse_proxy" ]; then
        [ "$input_reverse_proxy" = "null" ] && REVERSE_PROXY="" || REVERSE_PROXY="$input_reverse_proxy"
    fi

    read -p "请确认脚本路径 (回车跳过保持当前值: $SCRIPT_PATH, 输入null清空): " input_path
    if [ -n "$input_path" ]; then
        [ "$input_path" = "null" ] && SCRIPT_PATH="" || SCRIPT_PATH="$input_path"
    fi

    read -p "请输入定时任务时间 (cron格式，回车跳过保持当前值: $CRON_SCHEDULE, 输入null清空): " input_cron
    if [ -n "$input_cron" ]; then
        [ "$input_cron" = "null" ] && CRON_SCHEDULE="" || CRON_SCHEDULE="$input_cron"
    fi

    read -p "请输入端口 (回车跳过保持当前值: $PORT, 输入null清空): " input_port
    if [ -n "$input_port" ]; then
        [ "$input_port" = "null" ] && PORT="" || PORT="$input_port"
    fi

    read -p "请输入 MYTVSUPER_TOKEN (回车跳过保持当前值: $MYTVSUPER_TOKEN, 输入null清空): " input_token
    if [ -n "$input_token" ]; then
        [ "$input_token" = "null" ] && MYTVSUPER_TOKEN="" || MYTVSUPER_TOKEN="$input_token"
    fi

    read -p "请输入 HAMI_SESSION_ID (回车跳过保持当前值: $HAMI_SESSION_ID, 输入null清空): " input_id
    if [ -n "$input_id" ]; then
        [ "$input_id" = "null" ] && HAMI_SESSION_ID="" || HAMI_SESSION_ID="$input_id"
    fi

    read -p "请输入 HAMI_SERIAL_NO (回车跳过保持当前值: $HAMI_SERIAL_NO, 输入null清空): " input_serial
    if [ -n "$input_serial" ]; then
        [ "$input_serial" = "null" ] && HAMI_SERIAL_NO="" || HAMI_SERIAL_NO="$input_serial"
    fi

    read -p "请输入 HAMI_SESSION_IP (回车跳过保持当前值: $HAMI_SESSION_IP, 输入null清空): " input_ip
    if [ -n "$input_ip" ]; then
        [ "$input_ip" = "null" ] && HAMI_SESSION_IP="" || HAMI_SESSION_IP="$input_ip"
    fi

    read -p "请输入 HTTP_PROXY (回车跳过保持当前值: $HTTP_PROXY, 输入null清空): " input_http_proxy
    if [ -n "$input_http_proxy" ]; then
        [ "$input_http_proxy" = "null" ] && HTTP_PROXY="" || HTTP_PROXY="$input_http_proxy"
    fi

    read -p "请输入 HTTPS_PROXY (回车跳过保持当前值: $HTTPS_PROXY, 输入null清空): " input_https_proxy
    if [ -n "$input_https_proxy" ]; then
        [ "$input_https_proxy" = "null" ] && HTTPS_PROXY="" || HTTPS_PROXY="$input_https_proxy"
    fi

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

# 判断 Pixman 容器
check_update() {

    ARCH=$(uname -m)
    
    if [[ "$ARCH" == "armv7"* ]]; then
        IMAGE_SOURCE="pixman/pixman-armv7"
        PROXY_IMAGE_SOURCE="$REVERSE_PROXY/pixman-armv7"
    else
        IMAGE_SOURCE="pixman/pixman"
        PROXY_IMAGE_SOURCE="$REVERSE_PROXY/pixman/pixman"
    fi

    echo "正在安装 Pixman 项目 作者: @Pixman..."
    if docker ps -a --format '{{.Names}}' | grep -q "^pixman$"; then
        current_image_version=$(docker inspect --format='{{index .Config.Labels "org.opencontainers.image.version"}}' pixman)

        MODE=$(docker inspect --format='{{.HostConfig.NetworkMode}}' pixman)

        if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
            echo -e "${CYAN}尝试使用代理...${RESET}"
            if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
                echo -e "${RED}安装 Pixman 失败，请检查反向代理或网络连接。${RESET}"
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
        if ! docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^pixman/pixman$"; then
            if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
                echo "尝试使用代理..."
                if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
                    echo "使用代理拉取失败，请检查反向代理或网络连接。"
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

    if check_internet_connection; then
        install_watchtower "pixman"
    else
        echo "---------------------------------------------------------"
    fi
  
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
        docker images --format '{{.Repository}}:{{.Tag}}' | grep 'pixman/pixman' | xargs -r docker rmi > /dev/null 2>&1
        # rm -f "$SCRIPT_PATH"
        # rm -f "$CONFIG_FILE"
        # sed -i '/alias y=/d' ~/.bashrc
        uninstall_watchtower "pixman"
        echo -e "${RED}Pixman 项目 已成功卸载。${RESET}"
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

    echo "◆ 订阅地址："
    if check_internet_connection; then
        echo "■ 四季線上 4GTV : http://${public_ip}:${port}/4gtv.m3u （部分失效）"
        echo "■ MytvSuper : http://${public_ip}:${port}/mytvsuper.m3u （需填写会员参数）"
        echo "■ Hami Video : http://${public_ip}:${port}/hami.m3u （需填写会员参数）"
    fi
    echo "---------------------------------------------------------"
    echo "---  Pixman 详细使用说明: https://pixman.io/topics/17  ---"
    echo "--- NoobIPTV.sh 脚本日志: https://pixman.io/topics/142 ---"
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
            echo -e "${RED}网络环境不支持，目前已禁用 myTV 服务。${RESET}"
            return 1
        fi
    else
        echo -e "${CYAN}MYTVSUPER_TOKEN 参数不能为空，无法生成订阅。${RESET}"
        return 1
    fi

    echo "---------------------------------------------------------"
    echo "---  Pixman 详细使用说明: https://pixman.io/topics/17  ---"
    echo "--- NoobIPTV.sh 脚本日志: https://pixman.io/topics/142 ---"
    echo "---------------------------------------------------------"

    read -p "按 回车键 返回 主菜单 ..."
}

#############  Fourgtv #############

# 安装 Fourgtv
install_Fourgtv() {
    local public_ip
    local port=8000
    local ENV_VARS

    if check_if_in_china; then
        public_ip="{路由IP}"
    else
        public_ip=$(curl -s ifconfig.me || echo "{公网IP}")
    fi

    IMAGE_SOURCE="liuyong1987/fourgtv"
    PROXY_IMAGE_SOURCE="$REVERSE_PROXY/liuyong1987/fourgtv"
    echo "正在安装 Fourgtv 项目 作者: @刘墉..."
    if docker ps -a --format '{{.Names}}' | grep -q "^fourgtv$"; then
        echo -e "${CYAN}检测到已存在的 Fourgtv 容器，将进行检测更新...${RESET}"
        ENV_VARS=$(docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' fourgtv)
        port=$(echo "$ENV_VARS" | grep -oP 'PORT=\K\d+')
        port=${PORT:-8000}
        NOWSESSIONID=$(echo "$ENV_VARS" | grep -oP 'NOWSESSIONID=\K.*')
        NOWUSERAGENT=$(echo "$ENV_VARS" | grep -oP 'NOWUSERAGENT=\K.*')
        MYTVSUPER_TOKEN=$(echo "$ENV_VARS" | grep -oP 'MYTVSUPER_TOKEN=\K.*')

        echo -e "${CYAN}当前 Fourgtv 配置参数：${RESET}"
        echo "端口: $port"
        echo "NOWSESSIONID: $NOWSESSIONID"
        echo "NOWUSERAGENT: $NOWUSERAGENT"
        echo "MYTVSUPER_TOKEN: $MYTVSUPER_TOKEN"
        docker stop fourgtv > /dev/null 2>&1
        docker rm -f fourgtv > /dev/null 2>&1
        docker images --format '{{.Repository}}:{{.Tag}}' | grep 'liuyong1987/fourgtv' | xargs -r docker rmi > /dev/null 2>&1
    fi
    pull_image "$IMAGE_SOURCE" "$PROXY_IMAGE_SOURCE"
    echo "请输入 Fourgtv 配置参数："
    echo "当前 Fourgtv 使用的端口是 $port，是否需要修改？[y/n]（默认：n）"
    read -r -t 10 input_port
    input_port=${input_port:-n}

    if [[ "$input_port" =~ ^[Yy]$ ]]; then
        read -rp "请输入新的端口号: " port
    fi
    echo "是否需要修改其他环境变量？[y/n]（默认：n）"
    read -r -t 10 input_vars
    input_vars=${input_vars:-n}

    if [[ "$input_vars" =~ ^[Yy]$ ]]; then
        read -rp "请输入 NOWSESSIONID: " NOWSESSIONID
        read -rp "请输入 NOWUSERAGENT: " NOWUSERAGENT
        read -rp "请输入 MYTVSUPER_TOKEN: " MYTVSUPER_TOKEN
    fi
    echo "请选择 Fourgtv 部署方式（默认: 2):"
    echo "1) 使用 host 网络模式"
    echo "2) 使用 bridge 网络模式"
    read -rp "输入选项 (1 或 2): " option_fourgtv
    option_fourgtv=${option_fourgtv:-2}

    case $option_fourgtv in
        1|host)
            echo "正在使用 host 网络模式安装 Fourgtv..."
            docker run -d --restart always --net=host --privileged=true -p "$port:8000" --name fourgtv \
                -e NOWSESSIONID="$NOWSESSIONID" \
                -e NOWUSERAGENT="$NOWUSERAGENT" \
                -e MYTVSUPER_TOKEN="$MYTVSUPER_TOKEN" \
                "$IMAGE_SOURCE"
            ;;

        2|bridge)
            echo "正在使用 bridge 网络模式安装 Fourgtv..."
            docker run -d --restart always --net=bridge --privileged=true -p "$port:8000" --name fourgtv \
                -e NOWSESSIONID="$NOWSESSIONID" \
                -e NOWUSERAGENT="$NOWUSERAGENT" \
                -e MYTVSUPER_TOKEN="$MYTVSUPER_TOKEN" \
                "$IMAGE_SOURCE"
            ;;
    esac

    echo -e "${GREEN}Fourgtv 安装完成。${RESET}"

    if check_internet_connection; then
        install_watchtower "fourgtv"
    else
        echo "---------------------------------------------------------"
    fi

    live_Fourgtv "$public_ip" "$port"
}

# 生成 Fourgtv 订阅
live_Fourgtv() {
    local public_ip="$1"
    local port="$2"

    echo "◆ 订阅地址："
    echo "■ iTV : http://$public_ip:$port/itv.m3u （需消耗服务器流量）"
    echo "■ Beesport : http://$public_ip:$port/beesport.m3u （部分地区可直连）"
    echo "■ Now : http://$public_ip:$port/now.m3u （需填写会员参数,且需要原生IP）"
    echo "■ 4GTV : http://$public_ip:$port/4gtv.m3u (部分节目需要解锁台湾IP)"
    echo "■ MytvSuper  : http://$public_ip:$port/mytvsuper.m3u（需填写会员参数）"
    echo "---------------------------------------------------------"
    echo "---  Fourgtv 详细使用说明: https://t.me/livednowgroup  ---"
    echo "--- NoobIPTV.sh 脚本日志: https://pixman.io/topics/142 ---"
    echo "---------------------------------------------------------"

    read -p "按 回车键 返回 主菜单 ..."
}

# 卸载 Fourgtv
uninstall_Fourgtv() {
    echo "是否确定要卸载 Fourgtv 项目？[y/n]"
    read -r -t 10 input
    input=${input:-n}

    if [[ "$input" =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}正在卸载 Fourgtv 项目...${RESET}"
        docker stop fourgtv > /dev/null 2>&1
        docker rm -f fourgtv > /dev/null 2>&1
        docker images --format '{{.Repository}}:{{.Tag}}' | grep 'liuyong1987/fourgtv' | xargs -r docker rmi > /dev/null 2>&1
        uninstall_watchtower "fourgtv"
        echo -e "${RED}Fourgtv 项目 已成功卸载。${RESET}"
    else
        echo -e "${GREEN}取消卸载操作。${RESET}"
    fi
}

#############  Doubebly #############

# 安装 Doubebly
install_Doubebly() {
    echo "请选择安装方式："
    echo "1) 安装 doube-ofiii"
    echo "2) 安装 doube-itv"
    echo "3) 同时安装 doube-ofiii 和 doube-itv"
    
    read -rp "输入选项 (1, 2 或 3): " option
    option=${option:-1}

    local public_ip
    local port_ofiii=50002
    local port_itv=50001

    if check_if_in_china; then
        public_ip="{路由IP}"
    else
        public_ip=$(curl -s ifconfig.me || echo "{公网IP}")
    fi

    IMAGE_SOURCE_OFIII="doubebly/doube-ofiii"
    IMAGE_SOURCE_ITV="doubebly/doube-itv"
    PROXY_IMAGE_SOURCE_OFIII="$REVERSE_PROXY/doubebly/doube-ofiii"
    PROXY_IMAGE_SOURCE_ITV="$REVERSE_PROXY/doubebly/doube-itv"

    # 安装 doube-ofiii
    if [[ "$option" == "1" || "$option" == "3" ]]; then
        echo "正在安装 Doube-ofiii 项目 作者: @沐辰..."
        if docker ps -a --format '{{.Names}}' | grep -q "^doube-ofiii$"; then
            echo -e "${CYAN}检测到已存在的 doube-ofiii 容器，将进行检测更新...${RESET}"
            docker stop doube-ofiii > /dev/null 2>&1
            docker rm doube-ofiii > /dev/null 2>&1
            docker images --format '{{.Repository}}:{{.Tag}}' | grep 'doubebly/doube-ofiii' | xargs -r docker rmi > /dev/null 2>&1
        fi
        pull_image "$IMAGE_SOURCE_OFIII" "$PROXY_IMAGE_SOURCE_OFIII"
        docker run -d --restart always --net=bridge --privileged=true -p "$port_ofiii:5000" --name doube-ofiii "$IMAGE_SOURCE_OFIII"
        echo -e "${GREEN}doube-ofiii 安装完成。${RESET}"
    fi

    # 安装 doube-itv
    if [[ "$option" == "2" || "$option" == "3" ]]; then
        echo "正在安装 Doube-itv 项目 作者: @沐辰..."
        if docker ps -a --format '{{.Names}}' | grep -q "^doube-itv$"; then
            echo -e "${CYAN}检测到已存在的 doube-itv 容器，将进行检测更新...${RESET}"
            docker stop doube-itv > /dev/null 2>&1
            docker rm doube-itv > /dev/null 2>&1
            docker images --format '{{.Repository}}:{{.Tag}}' | grep 'doubebly/doube-itv' | xargs -r docker rmi > /dev/null 2>&1
        fi
        pull_image "$IMAGE_SOURCE_ITV" "$PROXY_IMAGE_SOURCE_ITV"
        docker run -d --restart always --net=bridge --privileged=true -p "$port_itv:5000" --name doube-itv "$IMAGE_SOURCE_ITV"
        echo -e "${GREEN}doube-itv 安装完成。${RESET}"
    fi

    if check_internet_connection; then
        if [[ "$option" == "1" || "$option" == "3" ]]; then
            install_watchtower "doube-ofiii"
        fi
        if [[ "$option" == "2" || "$option" == "3" ]]; then
            install_watchtower "doube-itv"
        fi
    else
        echo "---------------------------------------------------------"
    fi

    live_Doubebly "$public_ip" "$port_ofiii" "$port_itv" "$option"
}

# 生成 Doubebly 订阅
live_Doubebly() {
    local public_ip="$1"
    local port_ofiii="$2"
    local port_itv="$3"
    local option="$4"

    echo "◆ 订阅地址："
    if [[ "$option" == "1" || "$option" == "3" ]]; then
        echo "■ ofiii : http://${public_ip}:${port_ofiii}/help (浏览器获取订阅地址)"
    fi
    if [[ "$option" == "2" || "$option" == "3" ]]; then
        echo "■ iTV : http://${public_ip}:${port_itv}/help (浏览器获取订阅地址)"
    fi
    echo "---------------------------------------------------------"
    echo "---   Doubebly 详细使用说明: https://t.me/doubebly003 ---"
    echo "--- NoobIPTV.sh 脚本日志: https://pixman.io/topics/142 ---"
    echo "---------------------------------------------------------"

    read -p "按 回车键 返回 主菜单 ..."
}

# 卸载 Doubebly
uninstall_Doubebly(){
    echo "请选择要卸载的项目："
    echo "1) 卸载 doube-ofiii"
    echo "2) 卸载 doube-itv"
    echo "3) 同时卸载 doube-ofiii 和 doube-itv"
    
    read -rp "输入选项 (1, 2 或 3): " option
    option=${option:-1}

    # 检查 doube-ofiii 和 doube-itv 容器是否存在
    if docker ps -a --format '{{.Names}}' | grep -q "^doube-ofiii$"; then
        DOUBE_OFIII_EXIST=true
    else
        DOUBE_OFIII_EXIST=false
    fi

    if docker ps -a --format '{{.Names}}' | grep -q "^doube-itv$"; then
        DOUBE_ITV_EXIST=true
    else
        DOUBE_ITV_EXIST=false
    fi

    # 执行卸载操作
    if [[ "$option" == "1" || "$option" == "3" ]]; then
        if [ "$DOUBE_OFIII_EXIST" == true ]; then
            echo -e "${CYAN}正在卸载 doube-ofiii...${RESET}"
            docker stop doube-ofiii > /dev/null 2>&1
            docker rm -f doube-ofiii > /dev/null 2>&1
            docker images --format '{{.Repository}}:{{.Tag}}' | grep 'doubebly/doube-ofiii' | xargs -r docker rmi > /dev/null 2>&1
            uninstall_watchtower "doube-ofiii"
            echo -e "${RED}doube-ofiii 已成功卸载。${RESET}"
        else
            echo -e "${YELLOW}未找到 doube-ofiii 容器，跳过卸载操作。${RESET}"
        fi
    fi

    if [[ "$option" == "2" || "$option" == "3" ]]; then
        if [ "$DOUBE_ITV_EXIST" == true ]; then
            echo -e "${CYAN}正在卸载 doube-itv...${RESET}"
            docker stop doube-itv > /dev/null 2>&1
            docker rm -f doube-itv > /dev/null 2>&1
            docker images --format '{{.Repository}}:{{.Tag}}' | grep 'doubebly/doube-itv' | xargs -r docker rmi > /dev/null 2>&1
            uninstall_watchtower "doube-itv"
            echo -e "${RED}doube-itv 已成功卸载。${RESET}"
        else
            echo -e "${YELLOW}未找到 doube-itv 容器，跳过卸载操作。${RESET}"
        fi
    fi
}

#############  watchtower  #############

#一键 watchtower 更新
update_watchtower() {
    echo "===== 目前运行中的容器 ====="
    local running_containers=$(docker ps --format "{{.Names}}")
    
    if [ -n "$running_containers" ]; then
        echo "可选容器列表："
        local index=1
        all_container_map=()
        
        while IFS= read -r container; do
            all_container_map[$index]=$container
            echo "$index. $container"
            ((index++))
        done <<< "$running_containers"
        
        echo ""
        echo "容器总数: $((index-1))"

        read -p "请选择要更新的容器编号: " container_choice
        
        if [[ $container_choice -ge 1 && $container_choice -lt $index ]]; then
            local selected_container=${all_container_map[$container_choice]}
            echo -e "${CYAN}正在检测容器: $selected_container${RESET}"
            
            local watchtower_output
            watchtower_output=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower "$selected_container" --run-once -c 2>&1)
            
            local failed scanned updated
            if [[ $watchtower_output =~ Failed=([0-9]+) ]]; then
                failed="${BASH_REMATCH[1]}"
            fi
            if [[ $watchtower_output =~ Scanned=([0-9]+) ]]; then
                scanned="${BASH_REMATCH[1]}"
            fi
            if [[ $watchtower_output =~ Updated=([0-9]+) ]]; then
                updated="${BASH_REMATCH[1]}"
            fi

            if [[ $failed -eq 1 && $scanned -eq 1 && $updated -eq 0 ]]; then
                echo -e "${RED}检测失败。${RESET}"
            elif [[ $failed -eq 0 && $scanned -eq 1 && $updated -eq 0 ]]; then
                echo -e "${YELLOW}无需更新。${RESET}"
            elif [[ $failed -eq 0 && $scanned -eq 1 && $updated -eq 1 ]]; then
                echo -e "${GREEN}更新成功！${RESET}"
            else
                echo "未知的检测结果。"
            fi
        else
            echo "无效的选择。"
        fi
    else
        echo "没有运行中的容器。"
    fi
}

# 管理 Watchtower 监控容器
manage_watchtower() {
    declare -A all_container_map
    declare -A container_map

    show_monitored_containers() {
        existing_args=$(docker inspect --format '{{.Args}}' watchtower)
        monitored_containers=$(echo "$existing_args" | grep -oP '([a-zA-Z0-9\-]+)' | grep -vE "cleanup|c|s|^0$|^5$|\*")

        echo "===== Watchtower 当前监控的容器 ====="
        if [ -n "$monitored_containers" ]; then
            echo "监控的容器列表："
            local index=1
            container_map=()
            
            for container in $monitored_containers; do
                container_map[$index]=$container
                if docker ps --format "{{.Names}}" | grep -q "^$container$"; then
                    echo -e "$index. $container (运行中)"
                else
                    echo -e "$index. $container (未运行)"
                fi
                ((index++))
            done
            echo ""
            echo "容器总数: $((index-1))"
        else
            echo "当前没有监控任何容器。"
            return 1
        fi
    }

    show_all_containers() {
        echo "===== 目前运行中的容器 ====="
        local running_containers=$(docker ps --format "{{.Names}}" | grep -v "^watchtower$")
        if [ -n "$running_containers" ]; then
            echo "可选容器列表："
            local index=1
            all_container_map=()
            
            while IFS= read -r container; do
                all_container_map[$index]=$container
                echo "$index. $container"
                ((index++))
            done <<< "$running_containers"
            echo ""
            echo "容器总数: $((index-1))"
            return 0
        else
            echo "当前没有运行中的容器。"
            return 1
        fi
    }
    echo "Watchtower - 自动更新 Docker 镜像与容器"
    echo -e "请选择操作类型："
    echo "1. 添加监控容器"
    echo "2. 删除监控容器"
    read -rp "请输入选项 [1/2]：" action

    case "$action" in
        1)  # 添加容器
            if show_all_containers; then
                read -rp "请输入要添加到监控的容器编号：" number
                if [[ $number =~ ^[0-9]+$ ]] && [ -n "${all_container_map[$number]}" ]; then
                    name=${all_container_map[$number]}
                    install_watchtower "$name"
                else
                    echo "编号无效，请重试。"
                fi
            fi
            ;;
        2)  # 删除容器
            if show_monitored_containers; then
                read -rp "请输入要删除的监控容器编号：" number
                if [[ $number =~ ^[0-9]+$ ]] && [ -n "${container_map[$number]}" ]; then
                    name=${container_map[$number]}
                    uninstall_watchtower "$name"
                else
                    echo "编号无效，请重试。"
                fi
            fi
            ;;
        *)
            echo "无效选项，请选择 1 或 2。"
            ;;
    esac
}

# 增加 watchtower 监控
install_watchtower() {
    local name="$1"
    
    if [ -z "$name" ]; then
        echo -e "${RED}错误: 未指定要监控的容器名称${RESET}"
        return 1
    fi
    
    local monitored_containers=""
    
    if docker ps -q -f name=watchtower > /dev/null 2>&1; then
        existing_args=$(docker inspect --format '{{.Args}}' watchtower)
        monitored_containers=$(echo "$existing_args" | grep -oP '([a-zA-Z0-9\-]+)' | grep -vE "cleanup|c|s|^0$|^5$|\*")

        if echo "$monitored_containers" | grep -qw "$name"; then
            echo "---------------------------------------------------------"
            echo -e "${CYAN}■ 服务器将于每天凌晨五点，进行 $name 检测更新。${RESET}"
            echo "---------------------------------------------------------"
            return 0
        fi

        monitored_containers="${monitored_containers:+$monitored_containers }$name"
        
        docker stop watchtower > /dev/null 2>&1
        docker rm watchtower > /dev/null 2>&1
    else
        monitored_containers="$name"
    fi
    
    echo "正在安装或配置 Watchtower 并监控 $name 镜像更新..."
    
    IMAGE_SOURCE="containrrr/watchtower"
    PROXY_IMAGE_SOURCE="${REVERSE_PROXY}/containrrr/watchtower"
    
    if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
        echo -e "${CYAN}尝试使用代理拉取镜像...${RESET}"
        if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
            echo -e "${RED}安装 watchtower 失败，请检查反向代理或网络连接。${RESET}"
            return 1
        fi
        IMAGE_SOURCE="$PROXY_IMAGE_SOURCE"
    fi

    if ! docker run -d --name watchtower --restart always -e TZ=Asia/Shanghai -v /var/run/docker.sock:/var/run/docker.sock $IMAGE_SOURCE $monitored_containers -c -s "0 0 5 * * *" > /dev/null 2>&1; then
        echo -e "${RED}Watchtower 运行失败，请检查日志。${RESET}"
        return 1
    fi

    echo "---------------------------------------------------------"
    echo -e "${CYAN}■ 服务器将于每天凌晨五点，进行 $name 检测更新。${RESET}"
    echo "---------------------------------------------------------"
    return 0
}

# 删除 Watchtower 监控
uninstall_watchtower() {
    local name="$1"

    if docker ps -q -f name=watchtower > /dev/null 2>&1; then

        existing_args=$(docker inspect --format '{{.Args}}' watchtower)
        monitored_containers=$(echo "$existing_args" | grep -oP '([a-zA-Z0-9\-]+)' | grep -vE "cleanup|c|s|^0$|^5$|\*")

        if echo "$monitored_containers" | grep -qw "$name"; then
            # 移除指定容器名称
            monitored_containers=$(echo "$monitored_containers" | sed "s/\b$name\b//g" | xargs)

            if [ -z "$monitored_containers" ]; then
                echo "没有其他监控的容器，正在停止并删除 Watchtower..."
                docker stop watchtower > /dev/null 2>&1
                docker rm watchtower > /dev/null 2>&1
                docker images --format '{{.Repository}}:{{.Tag}}' | grep 'containrrr/watchtower' | xargs -r docker rmi > /dev/null 2>&1
                echo "Watchtower 已成功卸载。"
            else
                docker stop watchtower > /dev/null 2>&1
                docker rm watchtower > /dev/null 2>&1

                IMAGE_SOURCE="containrrr/watchtower"
                PROXY_IMAGE_SOURCE="${REVERSE_PROXY}/containrrr/watchtower"

                if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
                    echo -e "${CYAN}尝试使用代理拉取镜像...${RESET}"
                    if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
                        echo -e "${RED}安装 watchtower 失败，请检查反向代理或网络连接。${RESET}"
                        return 1
                    fi
                    IMAGE_SOURCE="$PROXY_IMAGE_SOURCE"
                fi 

                if ! docker run -d --name watchtower --restart always -e TZ=Asia/Shanghai -v /var/run/docker.sock:/var/run/docker.sock $IMAGE_SOURCE $monitored_containers -c -s "0 0 5 * * *" > /dev/null 2>&1; then
                    echo -e "${RED}Watchtower 运行失败，请检查日志。${RESET}"
                    return 1
                fi
                echo -e "${GREEN}$name${RESET} 容器已从监控中删除。"
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
    docker stop 3x-ui > /dev/null 2>&1
    docker rm 3x-ui > /dev/null 2>&1
    docker images --format '{{.Repository}}:{{.Tag}}' | grep 'mhsanaei/3x-ui' | xargs -r docker rmi > /dev/null 2>&1
    [ -d "$PWD/db" ] && rm -rf "$PWD/db"
    echo -e "${GREEN}3X-UI 卸载完成。${RESET}"
}

#############  o11  #############

# 安装 o11
install_o11() {
    if docker ps -a --format '{{.Names}}' | grep -q 'o11'; then
        echo -e "${RED}o11 已经安装，请先卸载再重新安装。${RESET}"
        return 1
    fi
    ARCH=$(uname -m)
    if [[ "$ARCH" != "arm"* && "$ARCH" != "aarch64" ]]; then
        echo "系统架构: $ARCH，支持安装 o11。"
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
    else
        echo "不支持的系统架构: $ARCH，o11 安装失败..."
        return
    fi
}

# 卸载 o11 
uninstall_o11() {
    read -p "您确定要卸载 o11 面板吗？(y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "卸载操作已取消。"
        return
    fi
    docker stop o11 > /dev/null 2>&1
    docker rm o11 > /dev/null 2>&1
    docker images --format '{{.Repository}}:{{.Tag}}' | grep 'wechatofficial/o11' | xargs -r docker rmi > /dev/null 2>&1
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

#############  Sub Store  #############

# 安装 Sub Store
install_sub_store() {

    if docker ps -a --format '{{.Names}}' | grep -q 'sub-store'; then
        echo -e "${RED}Sub Store 已经安装，请先卸载再重新安装。${RESET}"
        return 1
    fi

    echo "Sub Store 节点订阅管理工具，是否决定安装？ (y/n)"
    read -r confirmation
    if [[ ! "$confirmation" =~ ^[Yy]$ ]]; then
        echo "安装已取消。"
        return 0
    fi

    echo "开始安装 Sub Store..."
    local IMAGE_SOURCE="xream/sub-store"
    local PROXY_IMAGE_SOURCE="$REVERSE_PROXY/xream/sub-store"
    local frontend_backend_key=$(openssl rand -base64 15 | tr -dc 'a-zA-Z0-9' | head -c 20)

    if check_if_in_china; then
        local public_ip="{路由IP}"
    else
        local public_ip=$(curl -s ifconfig.me || echo "{公网IP}")
    fi

    echo "拉取 Sub Store 镜像中..."
    if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
        echo -e "${CYAN}尝试使用代理拉取镜像...${RESET}"
        if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
            echo -e "${RED}安装 Sub Store 失败，请检查反向代理或网络连接。${RESET}"
            exit 1
        fi
        IMAGE_SOURCE="$PROXY_IMAGE_SOURCE"
    fi

    echo "正在启动 Sub Store 容器..."

    if ! docker run -d --restart=always -e "SUB_STORE_CRON=50 23 * * *" -e "SUB_STORE_FRONTEND_BACKEND_PATH=/$frontend_backend_key" -p 3001:3001 -v /etc/sub-store:/opt/app/data --name sub-store "$IMAGE_SOURCE"; then
        echo "错误: 容器启动失败" >&2
        return 1
    fi

    echo "Sub Store 安装成功!"
    echo "访问地址: http://${public_ip}:3001?api=http://${public_ip}:3001/$frontend_backend_key"
}

# 卸载 Sub Store
uninstall_sub_store() {
    read -p "是否卸载 Sub Store？(y/n): " confirm
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        echo "正在卸载 Sub Store..."
        docker stop sub-store > /dev/null 2>&1
        docker rm -f sub-store > /dev/null 2>&1
        docker images --format '{{.Repository}}:{{.Tag}}' | grep 'xream/sub-store' | xargs -r docker rmi > /dev/null 2>&1
        echo -e "${RED}Sub Store 卸载完成。${RESET}"
    else
        echo -e "${GREEN}取消卸载操作。${RESET}"
    fi
}

#############  sing-box  #############

# 一键搭建节点
install_233boy() {
    echo "欢迎使用一键搭建节点脚本！"
    echo "此脚本将从 233boy 仓库安装 sing-box，请确保您信任此来源。"
    read -p "继续安装？(y/n): " confirm
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        echo "正在下载并运行安装脚本..."
        bash <(wget -qO- https://github.com/233boy/sing-box/raw/main/install.sh)
    else
        echo "安装已取消。"
    fi
}

#############  Alice 解锁  #############

# 一键搭建 Alice DNS解锁
install_Jimmy() {
    echo "欢迎使用一键 Alice DNS解锁 脚本！"
    echo "此脚本将从 Jimmyzxk 仓库安装 Alice 解锁，请确保您信任此来源。"
    read -p "继续安装？(y/n): " confirm
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        echo "正在下载并运行安装脚本..."
        wget https://raw.githubusercontent.com/Jimmyzxk/DNS-Alice-Unlock/refs/heads/main/dns-unlock.sh && bash dns-unlock.sh
        echo "详细使用说明: https://www.nodeseek.com/post-202393-1"
    else
        echo "安装已取消。"
    fi
}

#############  辅助函数  #############

# 拉取镜像
pull_image() {
    local image=$1
    local proxy_image=$2
    if ! docker pull "$image" > /dev/null 2>&1; then
        echo -e "${CYAN}尝试使用代理拉取镜像...${RESET}"
        if ! docker pull "$proxy_image" > /dev/null 2>&1; then
            echo -e "${RED}安装失败，请检查反向代理或网络连接。${RESET}"
            exit 1
        fi
    fi
}

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

# 检查 jq 工具 是否安装
check_and_install_jq() {
    if ! command -v jq &> /dev/null; then
        echo "jq 工具未安装，正在安装..."

        if check_if_in_china; then
            INSTALL_CMD="sudo apt-get update && sudo apt-get install -y jq --allow-releaseinfo-change"
        elif command -v apt-get &> /dev/null; then
            INSTALL_CMD="sudo apt-get update && sudo apt-get install -y jq"
        elif command -v yum &> /dev/null; then
            INSTALL_CMD="sudo yum install -y jq"
        elif command -v apk &> /dev/null; then
            INSTALL_CMD="sudo apk add --no-cache jq"
        elif command -v opkg &> /dev/null; then  # OpenWrt, Entware 环境
            INSTALL_CMD="opkg update && opkg install jq"
        else
            echo "无法识别该系统的包管理器，jq 安装失败。"
            return 1  # 无法识别包管理器，安装失败
        fi

        if ! eval "$INSTALL_CMD"; then
            echo "安装 jq 失败，请检查系统配置，将影响 参数 功能。"
            return 1  # 安装失败
        fi
    else
        return 0  # jq 已安装
    fi
}

# 检查 grep 工具 是否安装
check_and_install_grep() {
    if ! command -v grep &> /dev/null; then
        echo "grep 工具未安装，正在安装..."

        if check_if_in_china; then
            INSTALL_CMD="apt-get update && sudo apt-get install -y grep --allow-releaseinfo-change"
        elif command -v apt-get &> /dev/null; then
            INSTALL_CMD="sudo apt-get update && sudo apt-get install -y grep"
        elif command -v yum &> /dev/null; then
            INSTALL_CMD="sudo yum install -y grep"
        elif command -v apk &> /dev/null; then
            INSTALL_CMD="sudo apk add --no-cache grep"
        elif command -v opkg &> /dev/null; then  # OpenWrt, Entware 环境
            INSTALL_CMD="opkg update && opkg install grep"
        else
            echo "安装 grep 失败，请检查系统配置，将影响 Watchtower 功能。"
            return 1  # 安装失败
        fi

        # 执行安装命令
        if ! eval "$INSTALL_CMD"; then
            echo "安装 grep 失败，请检查系统配置，将影响 Watchtower 功能。"
            return 1  # 安装失败
        fi
    else
        return 0  # grep 已安装
    fi
}


# 设置反向代理参数
proxy_allinone() {
    read -p "请输入反向代理地址 (回车跳过保持当前值: $REVERSE_PROXY, 输入null清空): " input_reverse_proxy

    if [ -n "$input_reverse_proxy" ]; then
        [ "$input_reverse_proxy" = "null" ] && REVERSE_PROXY="" || REVERSE_PROXY="$input_reverse_proxy"
    fi

    echo "反向代理地址已更新为: ${REVERSE_PROXY:-<空>}"

    save_parameters
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

# 生成随机端口
generate_random_port() {
    local port
    while :; do
        port=$(shuf -i 10000-65535 -n 1)
        
        if ! ss -tuln | grep -q ":$port "; then
            echo "$port"
            break
        fi
    done
}

# # 检查并更新 SH 脚本
download_NoobIPTV() {
    REMOTE_VERSION=$(curl -s "https://yang-1989.eu.org/NoobIPTV_version.txt")

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
        echo "${GREEN}正在下载最新版本的 NoobIPTV 脚本...${RESET}"
        curl -o "$SCRIPT_PATH" "https://yang-1989.eu.org/NoobIPTV.sh"
        chmod +x "$SCRIPT_PATH"
        echo -e "${GREEN}最新 $REMOTE_VERSION 版本下载已完成。${RESET}"
    fi
}

# 设置快捷键
setup_shortcut() {
    local script_path="$HOME/NoobIPTV.sh"
    echo "脚本路径: $script_path"

    curl -sL https://yang-1989.eu.org/NoobIPTV.sh -o "$script_path"
    chmod +x "$script_path"

    local shell_rc="$HOME/.bashrc"
    echo "配置文件: $shell_rc"

    if [ -n "$shell_rc" ] && ! grep -q "alias y='bash $script_path'" "$shell_rc"; then
        echo "alias y='bash $script_path'" >> "$shell_rc"
        echo -e "${GREEN}已设置快捷键 'y'。${RESET}"
        source "$shell_rc" 2>/dev/null || true
        echo -e "${GREEN}快捷键已生效！现在可以使用 'y' 命令启动脚本。${RESET}"
    fi
}


# 检查是否是第一次运行
check_first_run() {
    local config_dir="$HOME/.config/NoobIPTV"
    local first_run_flag="$config_dir/initialized"
    
    if [ ! -d "$config_dir" ]; then
        mkdir -p "$config_dir"
    fi
    
    if [ ! -f "$first_run_flag" ]; then
        echo -e "${CYAN}首次运行，正在进行初始化设置...${RESET}"
        reload_configuration  # 加载配置参数
        setup_shortcut   # 设置快捷键
        touch "$first_run_flag"
    fi
}

# 脚本信息
script_log() {
    echo "------------------------------------------------"
    echo "项目名称：NoobIPTV"
    echo "项目地址：https://github.com/YanG-1989"
    echo "脚本日志: https://pixman.io/topics/142"
    echo "作者: YanG-1989"
    echo "当前版本号: $(grep -oP '(?<=^# 最新版本：).*' "$SCRIPT_PATH")"
    echo "最后更新时间: 2024.1.7"
    echo "1) 修复 Watchtower 删除容器的BUG "
    echo "2) 新增 Fourgtv 项目 作者: @刘墉 "
    echo "3) 新增 Doubebly 项目 作者: @沐辰 "
    echo "4) 删除 Allinone 项目 应 Token 受限 "
    echo "5) 删除 SH 定时任务 更新镜像 功能 "
    echo "------------------------------------------------"
    read -p "按 回车键 返回 主菜单 ..."
}

#############  主程序逻辑  #############

check_first_run  # 检查是否是第一次运行
download_NoobIPTV  # 检查并更新 SH 脚本
source "$CONFIG_FILE" # 加载配置文件中的参数

# 主循环
while true; do
    show_menu
    read -p "请选择操作: " choice
    case "$choice" in
        1)  # 部署 pixman 
            while true; do
                show_pixman_menu
                read -p "请输入选项 (0-5): " pixman_choice
                case "$pixman_choice" in
                    1) 
                        check_docker
                        check_update
                        live_pixman
                        ;;
                    2) 
                        set_parameters
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
        2)  # 部署 Fourgtv 
            while true; do
                show_fourgtv_menu
                read -p "请输入选项 (0-3): " fourgtv_choice
                case "$fourgtv_choice" in
                    1) check_docker ; install_Fourgtv ;;
                    2) uninstall_Fourgtv ;;
                    3) proxy_allinone ;;
                    0) echo "返回主菜单。" ; break ;;
                    *) echo "无效的选项，请输入 0-3。" ;;
                esac
            done
            ;;
        3)  # 部署 Doubebly 
            while true; do
                show_doubebly_menu
                read -p "请输入选项 (0-3): " doubebly_choice
                case "$doubebly_choice" in
                    1) check_docker ; install_Doubebly ;;
                    2) uninstall_Doubebly ;;
                    3) proxy_allinone ;;
                    0) echo "返回主菜单。" ; break ;;
                    *) echo "无效的选项，请输入 0-3。" ;;
                esac
            done
            ;;
        4)  # 管理 Docker 
            if ! check_internet_connection; then
                echo -e "${RED}网络环境不支持，目前禁用 watchtower 服务。${RESET}"
                break
            fi
            while true; do
                show_watchtower_menu
                read -p "请输入选项 (0-3): " watchtower_choice
                case "$watchtower_choice" in
                    1) update_watchtower ;;
                    2) manage_watchtower ;;
                    3) cleanup_docker ;;
                    0) echo "返回主菜单。" ; break ;;
                    *) echo "无效的选项，请输入 0-3。" ;;
                esac
            done
            ;;
        5)  # 工具箱
            while true; do
                show_toolbox_menu
                read -p "请输入选项 (0-6): " toolbox_choice
                case "$toolbox_choice" in
                    1) install_233boy ;;  # sing-box 
                    2)  # 1Panel
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
                    3)  # o11
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
                    4)  # 3X-UI
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
                    5)  # Sub Store
                        while true; do
                            show_subs_menu
                            read -p "请输入选项 (0-2): " Sub_choice
                            case "$Sub_choice" in
                                1) echo check_docker ; install_sub_store ;;    
                                2) echo uninstall_sub_store ;;
                                0) echo "返回上级菜单。" ; break ;;
                                *) echo "无效的选项，请输入 0-2。" ;;
                            esac
                        done
                        ;;
                    6) install_Jimmy ;;  # Alice DNS
                    0) echo "返回主菜单。" ; break ;;
                    *) echo "无效的选项，请输入 0-6。" ;;
                esac
            done
            ;;
        6) script_log ;;
        0) echo "退出脚本。" ; exit 0 ;;
        *) echo "无效的选项，请输入 0-6。" ;;
    esac
done
