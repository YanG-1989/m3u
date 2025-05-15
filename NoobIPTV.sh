#!/bin/bash
###############################
# 名称: NoobIPTV (IPTV 项目相关脚本集合 @小白神器) 
# 作者: YanG-1989
# 项目地址：https://github.com/YanG-1989
# 最新版本：2.1.2
###############################

# 设置路径
SCRIPT_PATH="$HOME/NoobIPTV.sh"  # 定义脚本路径
CONFIG_FILE="$HOME/.NoobIPTV"  # 配置文件路径
REVERSE_PROXY="docker.zhai.cm" # 设置反向代理地址

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
    echo "   请选择一个项目： "
    echo "-------------------"
    echo "1)  Pixman 项目    "
    echo "2)  Fourgtv 项目   "
    echo "3)  Doubebly 项目  "
    echo "~~~~~~~~~~~~~~~~~~~"
    echo "4) Docker 管理助手  "
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
    echo "1) 安装 Pixman  项目"
    echo "2) 卸载 Pixman  项目"
    echo "3) 设置 反向代理 地址"
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
    echo "4) 一键设置 Docker 日志"
    echo "----------------------"
    echo "0)    返回主菜单       "
    echo "----------------------"
}
 
# 工具箱 菜单
show_toolbox_menu() {
    echo "---------------------"
    echo "      工具箱菜单：    "
    echo "---------------------"
    echo "1) [Docker] 1Panel   "
    echo "2) [Docker] o11      "
    echo "3) [Docker] 3X-UI    "
    echo "4) [Docker] Sub Store"
    echo "5) [Docker] LibreTV  "
    echo "6) [233boy] Sing-box "
    echo "7) [Jimmy ] Alice DNS"
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

# libretv 菜单
show_libretv_menu() {
    echo "-------------------"
    echo "   LibreTV 菜单：  "
    echo "-------------------"
    echo "1)  安装 LibreTV   "
    echo "2)  卸载 LibreTV   "
    echo "-------------------"
    echo "0)  返回上级菜单    "
    echo "-------------------"
}

#############  Pixman  #############

# 判断 Pixman 容器
judge_Pixman() {
    local NETWORK_MODE PORT env_vars

    echo "正在安装 Pixman 项目 作者: @Pixman..."

    if docker ps -a --format '{{.Names}}' | grep -q "^pixman$"; then
        local MODE ENV_VARS

        ENV_VARS=$(docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' pixman)
        MYTVSUPER_TOKEN=$(echo "$ENV_VARS" | grep -oP 'MYTVSUPER_TOKEN=\K.*')
        HAMI_SESSION_ID=$(echo "$ENV_VARS" | grep -oP 'HAMI_SESSION_ID=\K.*')
        HAMI_SERIAL_NO=$(echo "$ENV_VARS" | grep -oP 'HAMI_SERIAL_NO=\K.*')
        HAMI_SESSION_IP=$(echo "$ENV_VARS" | grep -oP 'HAMI_SESSION_IP=\K.*')
        HTTP_PROXY=$(echo "$ENV_VARS" | grep -oP 'HTTP_PROXY=\K.*')
        HTTPS_PROXY=$(echo "$ENV_VARS" | grep -oP 'HTTPS_PROXY=\K.*')

        echo -e "${CYAN}检测到已存在的 Pixman 容器，将进行重新安装...${RESET}"
        echo -e "当前 ${GREEN}Pixman${RESET} 配置参数："
        [ -n "$MYTVSUPER_TOKEN" ] && echo "MYTVSUPER_TOKEN: $MYTVSUPER_TOKEN" || echo "MYTVSUPER_TOKEN: 未设置"
        [ -n "$HAMI_SESSION_ID" ] && echo "HAMI_SESSION_ID: $HAMI_SESSION_ID" || echo "HAMI_SESSION_ID: 未设置"
        [ -n "$HAMI_SERIAL_NO" ] && echo "HAMI_SERIAL_NO: $HAMI_SERIAL_NO" || echo "HAMI_SERIAL_NO: 未设置"
        [ -n "$HAMI_SESSION_IP" ] && echo "HAMI_SESSION_IP: $HAMI_SESSION_IP" || echo "HAMI_SESSION_IP: 未设置"
        [ -n "$HTTP_PROXY" ] && echo "HTTP_PROXY: $HTTP_PROXY" || echo "HTTP_PROXY: 未设置"
        [ -n "$HTTPS_PROXY" ] && echo "HTTPS_PROXY: $HTTPS_PROXY" || echo "HTTPS_PROXY: 未设置"


        docker rm -f pixman > /dev/null 2>&1
        docker rmi -f "$IMAGE_SOURCE" > /dev/null 2>&1
        install_Pixman "$MYTVSUPER_TOKEN" "$HAMI_SESSION_ID" "$HAMI_SERIAL_NO" "$HAMI_SESSION_IP" "$HTTP_PROXY" "$HTTPS_PROXY"
    else
        install_Pixman
    fi
}

# 安装 Pixman 容器
install_Pixman() {
    local PORT=$(check_and_allocate_port 5000)
    local ARCH IMAGE_SOURCE PROXY_IMAGE_SOURCE
    local MYTVSUPER_TOKEN="$1"
    local HAMI_SESSION_ID="$2"
    local HAMI_SERIAL_NO="$3"
    local HAMI_SESSION_IP="$4"
    local HTTP_PROXY="$5"
    local HTTPS_PROXY="$6"

    echo -e "${CYAN}开始配置 Pixman 参数...${RESET}"

    echo "请选择 Pixman 部署方式（默认: 2):"
    echo "1) 使用 host 网络模式 (建议:软路由)"
    echo "2) 使用 bridge 网络模式 (建议:VPS)"
    read -rp "输入选项 (1 或 2): " option_fourgtv
    option_fourgtv=${option_fourgtv:-2}
    case "$option_fourgtv" in
        1) NETWORK_MODE="host" ;;
        2) NETWORK_MODE="bridge" ;;
        *) 
            echo -e "${RED}无效选项，使用默认的 bridge 模式。${RESET}"
            NETWORK_MODE="bridge"
            ;;
    esac

    if [[ "$NETWORK_MODE" == "bridge" ]]; then
        read -p "请输入 Pixman 容器端口 (当前值: $PORT 输入null清空): " input_port
        if [ -n "$input_port" ]; then
            [ "$input_port" = "null" ] && PORT="" || PORT=$(check_and_allocate_port "$input_port")
        fi
    else
        PORT=""
    fi

    echo "是否需要设置其他环境变量？[y/n]（默认：n）"
    read -rp "输入选项: " configure_all_vars
    configure_all_vars=${configure_all_vars:-n}
    if [[ "$configure_all_vars" =~ ^[Yy]$ ]]; then
        local env_vars=("MYTVSUPER_TOKEN" "HAMI_SESSION_ID" "HAMI_SERIAL_NO" "HAMI_SESSION_IP" "HTTP_PROXY" "HTTPS_PROXY")
        for var in "${env_vars[@]}"; do
            local current_value=$(eval echo \$$var)
            read -p "请输入 ${var} (当前值: ${current_value:-未设置}, 输入null清空): " input_value
            if [ -n "$input_value" ]; then
                [ "$input_value" = "null" ] && eval $var="" || eval $var="$input_value"
            fi
        done
    else
        echo -e "${YELLOW}已跳过所有环境变量的设置。${RESET}"
    fi

    ARCH=$(uname -m)

    if [[ "$ARCH" == "armv7"* ]]; then
        IMAGE_SOURCE="pixman/pixman-armv7"
        PROXY_IMAGE_SOURCE="$REVERSE_PROXY/pixman-armv7"
    else
        IMAGE_SOURCE="pixman/pixman"
        PROXY_IMAGE_SOURCE="$REVERSE_PROXY/pixman/pixman"
    fi

    pull_image "$IMAGE_SOURCE" "$PROXY_IMAGE_SOURCE"

    local docker_command="docker run -d --name pixman --restart always"

    if [[ "$NETWORK_MODE" == "host" ]]; then
        docker_command+=" --net=host"
    else
        docker_command+=" --net=bridge -p $PORT:5000"
    fi

    for var in MYTVSUPER_TOKEN HAMI_SESSION_ID HAMI_SERIAL_NO HAMI_SESSION_IP HTTP_PROXY HTTPS_PROXY; do
        local value=$(eval echo \$$var)
        [ -n "$value" ] && docker_command+=" -e $var=$value"
    done

    docker_command+=" $IMAGE_SOURCE"

    echo -e "${CYAN}正在启动 Pixman 容器...${RESET}"
    eval "$docker_command"
    echo -e "${GREEN}Pixman 容器已成功启动！${RESET}"

    if check_internet_connection; then
        install_watchtower "pixman"
    else
        echo "---------------------------------------------------------"
    fi

    live_Pixman "$PORT"
}

# 生成 Pixman 订阅
live_Pixman() {
    local public_ip=$(get_public_ip)
    local port="$1"

    echo "◆ 订阅地址："
    echo "■ 四季線上 4GTV : http://$public_ip:$port/4gtv.m3u （部分失效）"
    echo "■ MytvSuper : http://$public_ip:$port/mytvsuper.m3u （需填写会员参数）"
    echo "■ Hami Video : http://$public_ip:$port/hami.m3u （需填写会员参数）"
    echo "---------------------------------------------------------"
    echo "---  Pixman 详细使用说明: https://pixman.io/topics/17  ---"
    echo "--- NoobIPTV.sh 脚本日志: https://pixman.io/topics/142 ---"
    echo "---------------------------------------------------------"

    read -p "按 回车键 返回 主菜单 ..."
}

# 卸载 Pixman 项目
uninstall_Pixman() {
    echo "是否确定要卸载 Pixman 项目？[y/n]（默认：n）"
    read -r -t 10 input
    input=${input:-n}

    if [[ "$input" =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}正在卸载 Pixman 项目...${RESET}"
        docker stop pixman > /dev/null 2>&1
        docker rm -f pixman > /dev/null 2>&1
        docker images --format '{{.Repository}}:{{.Tag}}' | grep 'pixman/pixman' | xargs -r docker rmi > /dev/null 2>&1
        uninstall_watchtower "pixman"
        echo -e "${RED}Pixman 项目 已成功卸载。${RESET}"
    else
        echo -e "${GREEN}取消卸载操作。${RESET}"
    fi
}

#############  Fourgtv #############

# 安装 Fourgtv
install_Fourgtv() {
    local public_ip
    local ENV_VARS
    local public_ip=$(get_public_ip)
    local port=$(check_and_allocate_port 8000)

    IMAGE_SOURCE="ru2025/fourgtv:latest"
    PROXY_IMAGE_SOURCE="$REVERSE_PROXY/ru2025/fourgtv:latest"
    echo "正在安装 Fourgtv 项目 作者: @刘墉..."

    if docker ps -a --format '{{.Names}}' | grep -q "^fourgtv$"; then
        echo -e "${CYAN}检测到已存在的 Fourgtv 容器，将进行重新安装...${RESET}"
        ENV_VARS=$(docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' fourgtv)
        NOWSESSIONID=$(echo "$ENV_VARS" | grep -oP 'NOWSESSIONID=\K.*')
        NOWUSERAGENT=$(echo "$ENV_VARS" | grep -oP 'NOWUSERAGENT=\K.*')
        MYTVSUPER_TOKEN=$(echo "$ENV_VARS" | grep -oP 'MYTVSUPER_TOKEN=\K.*')

        echo -e "当前 ${GREEN}Fourgtv${RESET} 配置参数："
        [ -n "$NOWSESSIONID" ] && echo "NOWSESSIONID: $NOWSESSIONID" || echo "NOWSESSIONID: 未设置"
        [ -n "$NOWUSERAGENT" ] && echo "NOWUSERAGENT: $NOWUSERAGENT" || echo "NOWUSERAGENT: 未设置"
        [ -n "$MYTVSUPER_TOKEN" ] && echo "MYTVSUPER_TOKEN: $MYTVSUPER_TOKEN" || echo "MYTVSUPER_TOKEN: 未设置"

        docker stop fourgtv > /dev/null 2>&1
        docker rm -f fourgtv > /dev/null 2>&1
        docker images --format '{{.Repository}}:{{.Tag}}' | grep 'ru2025/fourgtv:latest' | xargs -r docker rmi > /dev/null 2>&1
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
    echo "1) 使用 host 网络模式 (建议:软路由)"
    echo "2) 使用 bridge 网络模式 (建议:VPS)"
    read -rp "输入选项 (1 或 2): " option_fourgtv
    option_fourgtv=${option_fourgtv:-2}

    case $option_fourgtv in
        1|host)
            echo "正在使用 host 网络模式安装 Fourgtv..."
            docker run -d --restart always --net=host -p $port:8000 --name fourgtv \
                ${NOWSESSIONID:+-e NOWSESSIONID=$NOWSESSIONID} \
                ${NOWUSERAGENT:+-e NOWUSERAGENT=$NOWUSERAGENT} \
                ${MYTVSUPER_TOKEN:+-e MYTVSUPER_TOKEN=$MYTVSUPER_TOKEN} \
                $IMAGE_SOURCE
            ;;

        2|bridge)
            echo "正在使用 bridge 网络模式安装 Fourgtv..."
            docker run -d --restart always --net=bridge -p $port:8000 --name fourgtv \
                ${NOWSESSIONID:+-e NOWSESSIONID=$NOWSESSIONID} \
                ${NOWUSERAGENT:+-e NOWUSERAGENT=$NOWUSERAGENT} \
                ${MYTVSUPER_TOKEN:+-e MYTVSUPER_TOKEN=$MYTVSUPER_TOKEN} \
                $IMAGE_SOURCE
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
    echo "■ 4GTV : http://$public_ip:$port/4gtv.m3u (部分节目需要解锁台湾IP)"
    echo "■ MytvSuper : http://$public_ip:$port/mytvsuper.m3u（需填写会员参数）"
    echo "■ Now : http://$public_ip:$port/now.m3u （收费频道,需填写会员参数、原生IP）"
    echo "■ Now : http://$public_ip:$port/now-free.m3u （免费频道,需填写会员参数、原生IP）"
    echo "■ YouTube : http://$public_ip:$port/youtube/{房间号} （支持列表 list/{列表号} ）"
    echo "---------------------------------------------------------"
    echo "---  Fourgtv 详细使用说明: https://t.me/livednowgroup  ---"
    echo "--- NoobIPTV.sh 脚本日志: https://pixman.io/topics/142 ---"
    echo "---------------------------------------------------------"

    read -p "按 回车键 返回 主菜单 ..."
}

# 卸载 Fourgtv
uninstall_Fourgtv() {
    echo "是否确定要卸载 Fourgtv 项目？[y/n]（默认：n）"
    read -r -t 10 input
    input=${input:-n}

    if [[ "$input" =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}正在卸载 Fourgtv 项目...${RESET}"
        docker stop fourgtv > /dev/null 2>&1
        docker rm -f fourgtv > /dev/null 2>&1
        docker images --format '{{.Repository}}:{{.Tag}}' | grep 'ru2025/fourgtv:latest' | xargs -r docker rmi > /dev/null 2>&1
        uninstall_watchtower "fourgtv"
        echo -e "${RED}Fourgtv 项目 已成功卸载。${RESET}"
    else
        echo -e "${GREEN}取消卸载操作。${RESET}"
    fi
}

#############  Doubebly #############

# 安装 Doubebly
install_Doubebly() {
    local public_ip=$(get_public_ip)
    local port_ofiii=$(check_and_allocate_port 50002)
    echo -e "${YELLOW}==================================================${RESET}"
    echo -e "${YELLOW}提示：如果你使用的是软路由，请移步 Telegram 查看安装教程${RESET}"
    echo -e "${CYAN}👉 https://t.me/doubebly003${RESET}"
    echo -e "${YELLOW}==================================================${RESET}"
    read -rp "是否继续安装 Doubebly？[y/n]（默认：n） " confirm_install
    confirm_install=${confirm_install:-n}

    if [[ ! "$confirm_install" =~ ^[Yy]$ ]]; then
        echo -e "${RED}安装已取消。${RESET}"
        return
    fi
    
    echo "请输入订阅使用的 Token（默认: Doubebly）:"
    read -rp "Token: " my_token
    my_token=${my_token:-Doubebly}

    echo "请输入 DNS 解锁 IP（例如 Alice 提供的）："
    read -rp "DNS IP（默认: 8.8.8.8）: " custom_dns
    custom_dns=${custom_dns:-8.8.8.8}

    if docker ps -a --format '{{.Names}}' | grep -q "^doube-ofiii$"; then
        echo -e "${CYAN}检测到已存在的 doube-ofiii 容器，正在重新部署...${RESET}"
        docker stop doube-ofiii >/dev/null 2>&1
        docker rm doube-ofiii >/dev/null 2>&1
    fi

    docker pull doubebly/doube-ofiii:1.1.3
    docker run -d --name=doube-ofiii \
        -p ${port_ofiii}:5000 \
        -e MY_OFIII_TOKEN="${my_token}" \
        --restart=always \
        --dns=${custom_dns} \
        doubebly/doube-ofiii:1.1.3

    echo -e "${GREEN}doube-ofiii 安装完成。${RESET}"
    if check_internet_connection; then
        install_watchtower "doube-ofiii"
    else
        echo "---------------------------------------------------------"
    fi

    echo "◆ 订阅地址："
    echo "◆ 直播TXT订阅地址: http://${public_ip}:${port_ofiii}/Sub.txt"
    echo "◆ 直播M3U订阅地址: http://${public_ip}:${port_ofiii}/Sub.m3u"
    echo "◆ 点播M3U订阅地址: http://${public_ip}:${port_ofiii}/Sub.vod.m3u?pids=ofiii75"
    echo
    echo "📌 加参数方式示例："
    echo "▶ http://${public_ip}:${port_ofiii}/Sub.m3u?token=${my_token}&sd=720&proxy=true"
    echo "▶ http://${public_ip}:${port_ofiii}/Sub.vod.m3u?token=${my_token}&sd=720&proxy=true&pids=ofiii75,ofiii76"
    echo "---------------------------------------------------------"
    echo "---   Doubebly 详细使用说明: https://t.me/doubebly003 ----"
    echo "--- NoobIPTV.sh 脚本日志: https://pixman.io/topics/142 ---"
    echo "---------------------------------------------------------"

    read -p "按 回车键 返回主菜单 ..."
}

# 卸载 Doubebly
uninstall_Doubebly() {
    echo "是否卸载 doube-ofiii 容器？"
    echo "1) 卸载 doube-ofiii"
    echo "2) 取消操作"

    read -rp "输入选项 (1 或 2): " option
    option=${option:-1}

    if [[ "$option" != "1" ]]; then
        echo "已取消卸载操作。"
        return
    fi

    if docker ps -a --format '{{.Names}}' | grep -q "^doube-ofiii$"; then
        echo -e "${CYAN}正在卸载 doube-ofiii...${RESET}"
        docker stop doube-ofiii > /dev/null 2>&1
        docker rm -f doube-ofiii > /dev/null 2>&1
        docker images --format '{{.Repository}}:{{.Tag}}' | grep 'doubebly/doube-ofiii' | xargs -r docker rmi > /dev/null 2>&1
        uninstall_watchtower "doube-ofiii"
        echo -e "${RED}doube-ofiii 已成功卸载。${RESET}"
    else
        echo -e "${YELLOW}未找到 doube-ofiii 容器，跳过卸载操作。${RESET}"
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
    local public_ip=$(get_public_ip)

    echo "请选择部署方式："
    echo "1) 使用 host 网络模式 (添加节点方便)"
    echo "2) 使用 bridge 网络模式 (添加节点,需映射端口)"
    echo "3) 使用 sh 脚本 直接安装 (推荐)"
    read -rp "输入选项 (1-3): " option

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
    read -p "您确定要卸载 3X-UI 面板吗？[y/n]（默认：n）" confirm
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
        local port=$(check_and_allocate_port 1234)
        local public_ip=$(get_public_ip)

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
    local public_ip=$(get_public_ip)

    read -p "您确定要卸载 o11 面板吗？[y/n]（默认：n）" confirm
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
    read -p "您确定要卸载 1Panel 吗？[y/n]（默认：n）" confirm
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
    local public_ip=$(get_public_ip)

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
    read -p "是否卸载 Sub Store？[y/n]（默认：n）" confirm
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

#############  LibreTV  #############

install_libretv() {

    if docker ps -a --format '{{.Names}}' | grep -q 'libretv'; then
        echo -e "${RED}LibreTV 已经安装，请先卸载再重新安装。${RESET}"
        return 1
    fi

    echo "LibreTV 视频搜索引擎，是否决定安装？ (y/n)"
    read -r confirmation
    if [[ ! "$confirmation" =~ ^[Yy]$ ]]; then
        echo "安装已取消。"
        return 0
    fi

    echo "请输入访问密码（可留空，默认无密码）:"
    read -r password

    echo "开始安装 LibreTV..."
    local IMAGE_SOURCE="bestzwei/libretv:latest"
    local PROXY_IMAGE_SOURCE="$REVERSE_PROXY/bestzwei/libretv:latest"

    echo "拉取 LibreTV 镜像中..."
    if ! docker pull "$IMAGE_SOURCE" > /dev/null 2>&1; then
        echo -e "${CYAN}尝试使用代理拉取镜像...${RESET}"
        if ! docker pull "$PROXY_IMAGE_SOURCE" > /dev/null 2>&1; then
            echo -e "${RED}安装 LibreTV 失败，请检查反向代理或网络连接。${RESET}"
            return 1
        fi
        IMAGE_SOURCE="$PROXY_IMAGE_SOURCE"
    fi

    echo "正在启动 LibreTV 容器..."

    if ! docker run -d --name libretv --restart=always -p 8899:80 -e PASSWORD="${password}" "$IMAGE_SOURCE"; then
        echo "错误: 容器启动失败" >&2
        return 1
    fi

    echo "LibreTV 安装成功!"
    echo "访问地址: http://${public_ip}:8899"
    if [[ -n "$password" ]]; then
        echo "登录密码: ${password}"
    else
        echo "当前无访问密码保护。"
    fi
}

uninstall_libretv() {
    read -p "是否卸载 LibreTV？[y/n]（默认：n）" confirm
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        echo "正在卸载 LibreTV..."
        docker stop libretv > /dev/null 2>&1
        docker rm -f libretv > /dev/null 2>&1
        docker images --format '{{.Repository}}:{{.Tag}}' | grep 'bestzwei/libretv' | xargs -r docker rmi > /dev/null 2>&1
        echo -e "${RED}LibreTV 卸载完成。${RESET}"
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
        docker tag "$proxy_image" "$image"
        docker rmi "$proxy_image"
    fi
}

# 检查 访问境外 是否受限
check_internet_connection() {
    if curl -s --connect-timeout 5 --max-time 10 --retry 2 google.com > /dev/null 2>&1; then
        return 0  # 无受限
    else
        return 1  # 受限
    fi
}

# 获取公网 IP / 失败返回 {路由IP}
get_public_ip() {
    # IPv4
    ip=$(curl -s --max-time 3 https://ipv4.icanhazip.com | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}')
    if [[ -n "$ip" ]]; then
        echo "$ip"
        return 0
    fi

    # IPv6
    ip=$(curl -s --max-time 3 https://ipv6.icanhazip.com | grep -oE '([0-9a-fA-F:]+:+)+[0-9a-fA-F]+')
    if [[ -n "$ip" ]]; then
        echo "$ip"
        return 0
    fi

    echo "{路由IP}"
    return 1
}

# 检查 IP 归属地
check_if_in_china() {
    local ip="$1"
    local response

    response=$(curl -s --max-time 3 "http://ip-api.com/json/$ip")
    if echo "$response" | grep -qiE '"country"[[:space:]]*:[[:space:]]*"?(CN|China)"?|中国'; then
        return 0
    fi
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
proxy() {
    source "$CONFIG_FILE"

    read -p "请输入反向代理地址 (当前值: ${REVERSE_PROXY:-未设置}, 输入null清空): " input_reverse_proxy

    if [ -n "$input_reverse_proxy" ]; then
        [ "$input_reverse_proxy" = "null" ] && REVERSE_PROXY="" || REVERSE_PROXY="$input_reverse_proxy"
    fi

    echo "反向代理地址已更新为: ${REVERSE_PROXY:-<空>}"
    echo "REVERSE_PROXY=${REVERSE_PROXY:-}" > "$CONFIG_FILE"
}

# 清理 Docker 工具
cleanup_docker() {
    echo -e "\n${YELLOW}┌─────────────────── Docker 完全清理 ───────────────────┐${RESET}"
    echo -e "${YELLOW}│${RESET} 此操作将执行:                                         ${YELLOW}│${RESET}"
    echo -e "${YELLOW}│${RESET} • 删除所有已停止的容器                                ${YELLOW}│${RESET}"
    echo -e "${YELLOW}│${RESET} • 删除所有未使用的镜像和构建缓存                      ${YELLOW}│${RESET}"
    echo -e "${YELLOW}│${RESET} • 删除所有未使用的卷和网络                            ${YELLOW}│${RESET}"
    echo -e "${YELLOW}│${RESET} • 清空所有容器的日志文件                              ${YELLOW}│${RESET}"
    echo -e "${YELLOW}└───────────────────────────────────────────────────────┘${RESET}"
    
    echo -e "\n${RED}⚠️  警告：此操作将删除大量数据，且无法恢复!${RESET}"
    read -p "$(echo -e "${CYAN}确认执行完全清理? (y/n，默认n): ${RESET}")" confirm
    confirm=${confirm:-n}
    
    if [[ "$confirm" != "y" ]]; then
        echo -e "\n${YELLOW}清理操作已取消${RESET}"
        read -p "$(echo -e "${CYAN}按回车键返回主菜单...${RESET}")"
        return
    fi
    
    # 统计数据
    container_count=0
    cleaned_logs=0
    total_freed=0
    
    # 第1步：清理容器日志
    echo -e "\n${YELLOW}[1/2] 正在清理容器日志...${RESET}"
    
    for container_id in $(docker ps -aq); do
        container_count=$((container_count+1))
        container_name=$(docker inspect --format '{{.Name}}' $container_id | sed 's/\///')
        log_path=$(docker inspect --format='{{.LogPath}}' $container_id)
        
        if [ -f "$log_path" ]; then
            log_size=$(du -b "$log_path" | awk '{print $1}')
            total_freed=$((total_freed + log_size))
            
            if [ $log_size -ge 1073741824 ]; then 
                log_size_h=$(echo "scale=2; $log_size/1073741824" | bc)
                log_size_h="${log_size_h} GB"
            elif [ $log_size -ge 1048576 ]; then
                log_size_h=$(echo "scale=2; $log_size/1048576" | bc)
                log_size_h="${log_size_h} MB"
            elif [ $log_size -ge 1024 ]; then
                log_size_h=$(echo "scale=2; $log_size/1024" | bc)
                log_size_h="${log_size_h} KB"
            else
                log_size_h="${log_size} bytes"
            fi
            
            echo -e "${GREEN}✓${RESET} 清理容器 ${CYAN}${container_name}${RESET} 日志 (${log_size_h})"
            echo "" > "$log_path"
            cleaned_logs=$((cleaned_logs+1))
        fi
    done
    
    if [ $total_freed -ge 1073741824 ]; then 
        total_freed_h=$(echo "scale=2; $total_freed/1073741824" | bc)
        total_freed_h="${total_freed_h} GB"
    elif [ $total_freed -ge 1048576 ]; then
        total_freed_h=$(echo "scale=2; $total_freed/1048576" | bc)
        total_freed_h="${total_freed_h} MB"
    elif [ $total_freed -ge 1024 ]; then
        total_freed_h=$(echo "scale=2; $total_freed/1024" | bc)
        total_freed_h="${total_freed_h} KB"
    else
        total_freed_h="${total_freed} bytes"
    fi
    
    # 第2步：执行Docker系统清理
    echo -e "\n${YELLOW}[2/2] 正在执行Docker系统清理...${RESET}"
    docker_prune_output=$(docker system prune -a --volumes -f)
    
    # 总结结果
    echo -e "\n${GREEN}══════════════ 清理完成 ══════════════${RESET}"
    echo -e "${GREEN}• 检查了 ${container_count} 个容器${RESET}"
    echo -e "${GREEN}• 清理了 ${cleaned_logs} 个日志文件 (释放约 ${total_freed_h})${RESET}"
    echo -e "${GREEN}• 执行了Docker系统完全清理${RESET}"
    echo -e "${GREEN}══════════════════════════════════════${RESET}"
    
    echo
    read -p "$(echo -e "${CYAN}按回车键返回主菜单...${RESET}")"
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

# 检查端口
check_and_allocate_port() {
    local port=$1
    if ss -tuln | grep -q ":$port "; then
        echo "端口 $port 已被占用，正在分配新的端口..."
        port=$(generate_random_port)
    fi
    echo "$port"
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

# 展示广告
show_NoobIPTV() {
echo -e "${CYAN}───────────────────────────────────────────────────────────────────────${RESET}
${RED}   ███╗   ██╗ ██████╗  ██████╗ ██████╗ ██╗██████╗ ████████╗██╗   ██╗${RESET}
${RED}   ████╗  ██║██╔═══██╗██╔═══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██║   ██║${RESET}
${RED}   ██╔██╗ ██║██║   ██║██║   ██║██████╔╝██║██████╔╝   ██║   ██║   ██║${RESET}
${RED}   ██║╚██╗██║██║   ██║██║   ██║██╔══██╗██║██╔═══╝    ██║   ╚██╗ ██╔╝${RESET}
${RED}   ██║ ╚████║╚██████╔╝╚██████╔╝██████╔╝██║██║        ██║    ╚████╔╝ ${RESET}
${RED}   ╚═╝  ╚═══╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝╚═╝        ╚═╝     ╚═══╝  ${RESET}  
${GREEN}            欢迎关注我们的 ${YELLOW}Telegram ${GREEN}频道: ${CYAN}@Y_anGGGGGG${RESET}
${CYAN}───────────────────────────────────────────────────────────────────────${RESET}
${YELLOW}        IPTV项目小白必备的搭建脚本和便捷工具箱，输入 ${GREEN}y${YELLOW} 快捷启动！${RESET}"
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
        [ ! -f "$CONFIG_FILE" ] && echo "REVERSE_PROXY=$REVERSE_PROXY" > "$CONFIG_FILE" # 设置配置文件
        setup_shortcut   # 设置快捷键
        touch "$first_run_flag"
    fi
}

# 脚本信息
script_log() {
    show_NoobIPTV
    echo "------------------------------------------------"
    echo "项目名称：NoobIPTV"
    echo "项目地址：https://github.com/YanG-1989"
    echo "脚本日志: https://pixman.io/topics/142"
    echo "作者: YanG-1989"
    echo "当前版本号: $(grep -oP '(?<=^# 最新版本：).*' "$SCRIPT_PATH")"
    echo "最后更新时间: 2024.5.15"
    echo "1) 优化 Docker 管理助手 "
    echo "2) 新增 LibreTV 快捷部署"
    echo "3) 修复 Fourgtv 项目 作者: @刘墉 "
    echo "4) 更新 Doubebly 项目 作者: @沐辰 "
    echo "------------------------------------------------"
    read -p "按 回车键 返回 主菜单 ..."
}

#############  主程序逻辑  #############

show_NoobIPTV
check_first_run  # 检查是否是第一次运行
download_NoobIPTV  # 检查并更新 SH 脚本
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"  # 加载配置文件中的参数

# 主循环
while true; do
    show_menu
    read -p "请选择操作: " choice
    case "$choice" in
        1)  # 部署 pixman 
            while true; do
                show_pixman_menu
                read -p "请输入选项 (0-3): " pixman_choice
                case "$pixman_choice" in
                    1) check_docker ; judge_Pixman ;;
                    2) uninstall_Pixman ;;
                    3) proxy ;;
                    0) echo "返回主菜单。" ; break ;;
                    *) echo "无效的选项，请输入 0-3。" ;;
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
                    3) proxy ;;
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
                    3) proxy ;;
                    0) echo "返回主菜单。" ; break ;;
                    *) echo "无效的选项，请输入 0-3。" ;;
                esac
            done
            ;;
        4)  # 管理 Docker 
            while true; do
                show_watchtower_menu
                read -p "请输入选项 (0-4): " watchtower_choice
                case "$watchtower_choice" in
                    1)  # 手动 watchtower 
                        if check_internet_connection; then
                            update_watchtower
                        else
                            echo -e "\n${RED}⚠️ 网络连接异常，无法执行更新操作${RESET}"
                            echo -e "${YELLOW}请检查网络连接后再尝试此功能${RESET}"
                            echo -e "按任意键继续..."
                            read -n 1
                        fi
                        ;;
                    2)  # 管理 watchtower 
                        if check_internet_connection; then
                            manage_watchtower
                        else
                            echo -e "\n${RED}⚠️ 网络连接异常，无法执行管理操作${RESET}"
                            echo -e "${YELLOW}请检查网络连接后再尝试此功能${RESET}"
                            echo -e "按任意键继续..."
                            read -n 1
                        fi
                        ;;
                    3) cleanup_docker ;; # 清理 Docker 垃圾
                    4)  # 设置 Docker 全局日志大小 
                       curl -L -s https://yang-1989.eu.org/docker.sh | sudo bash
                       echo -e "\n配置完成! 按任意键继续..."
                       read -n 1
                       ;;
                    0) echo "返回主菜单。" ; break ;;
                    *) echo "无效的选项，请输入 0-4。" ;;
                esac
            done
            ;;
        5)  # 工具箱 
            while true; do
                show_toolbox_menu
                read -p "请输入选项 (0-7): " toolbox_choice
                case "$toolbox_choice" in
                    1)  # 1Panel
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
                    2)  # o11
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
                    3)  # 3X-UI
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
                    4)  # Sub Store
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
                    5)  # LibreTV
                        while true; do
                            show_libretv_menu
                            read -p "请输入选项 (0-2): " LibreTV_choice
                            case "$LibreTV_choice" in
                                1) check_docker ; install_libretv ;;    
                                2) echo uninstall_libretv ;;
                                0) echo "返回上级菜单。" ; break ;;
                                *) echo "无效的选项，请输入 0-2。" ;;
                            esac
                        done
                        ;;
                    6) install_233boy ;;  # sing-box 
                    7) install_Jimmy ;;  # Alice DNS
                    0) echo "返回主菜单。" ; break ;;
                    *) echo "无效的选项，请输入 0-7。" ;;
                esac
            done
            ;;
        6) script_log ;;
        0) echo "退出脚本。" ; exit 0 ;;
        *) echo "无效的选项，请输入 0-6。" ;;
    esac
done
