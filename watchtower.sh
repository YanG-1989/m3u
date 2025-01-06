#!/bin/bash
###############################
# Watchtower 管理工具
# 作者: YanG-1989
# 项目地址：https://github.com/YanG-1989
# 最新版本：1.0.0
###############################

# 设置颜色变量
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"


# 显示主菜单
show_watchtower_menu() {
    echo "----------------------"
    echo "    Watchtower 菜单：  "
    echo "----------------------"
    echo "1) 一键更新 Docker 项目"
    echo "2) 管理 Docker 项目更新"
    echo "3) 一键清理 Docker 垃圾"
    echo "----------------------"
    echo "0)      退出脚本       "
    echo "----------------------"
}

# 一键更新指定容器
update_watchtower() {
    echo "===== 目前运行中的容器 ====="
    local running_containers=$(docker ps --format "{{.Names}}")
    
    if [ -n "$running_containers" ]; then
        echo "可选容器列表："
        local index=1
        declare -A all_container_map
        
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

# 安装/配置 Watchtower
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

# 清理 Docker 工具
cleanup_docker() {
    echo -e "🚨 警告：此操作将删除所有已停止的容器、未使用的镜像和卷。"
    read -p "你确认要继续吗？(y/n，默认n): " confirm
    confirm=${confirm:-n}

    if [[ "$confirm" != "y" ]]; then
        echo -e "${RED}清理已取消。${RESET}"
        return
    fi

    docker system prune -a --volumes -f

    echo -e "${GREEN}🎉 清理完成。${RESET}"
}

# 设置快捷键
setup_shortcut() {
    local script_path="$HOME/watchtower.sh"
    echo "脚本路径: $script_path"

    curl -sL https://yang-1989.eu.org/watchtower.sh -o "$script_path"
    chmod +x "$script_path"

    local shell_rc="$HOME/.bashrc"  # root 用户的情况下要确保是 /root/.bashrc
    echo "配置文件: $shell_rc"

    if [ -n "$shell_rc" ] && ! grep -q "alias wt='bash $script_path'" "$shell_rc"; then
        echo "alias wt='bash $script_path'" >> "$shell_rc"
        echo -e "${GREEN}已设置快捷键 'wt'。${RESET}"
        source "$shell_rc" 2>/dev/null || true
        echo -e "${GREEN}快捷键已生效！现在可以使用 'wt' 命令启动脚本。${RESET}"
    fi
}

# 检查是否是第一次运行
check_first_run() {
    local config_dir="$HOME/.config/watchtower"
    local first_run_flag="$config_dir/initialized"
    
    if [ ! -d "$config_dir" ]; then
        mkdir -p "$config_dir"
    fi
    
    if [ ! -f "$first_run_flag" ]; then
        echo -e "${CYAN}首次运行，正在进行初始化设置...${RESET}"
        setup_shortcut
        # 创建标记文件
        touch "$first_run_flag"
    fi
}


# 主程序入口
main() {
    # 添加首次运行检查
    check_first_run
    
    while true; do
        show_watchtower_menu
        read -p "请选择操作 [0-4]: " choice
        case $choice in
            0)
                echo "退出脚本..."
                exit 0
                ;;
            1)
                update_watchtower
                ;;
            2)
                manage_watchtower
                ;;
            3)
                cleanup_docker
                ;;
            *)
                echo "无效的选择，请重试。"
                ;;
        esac
        echo ""
        read -p "按 Enter 键继续..."
    done
}

# 执行主程序
main