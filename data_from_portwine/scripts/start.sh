#!/usr/bin/env bash
# Author: Castro-Fidel (linux-gaming.ru)
# Development assistants: Cefeiko; Dezert1r; Taz_mania; Anton_Famillianov; gavr; RidBowt; chal55rus; UserDiscord; Boria138; Vano; Akai; Htylol
# shellcheck disable=SC2140,SC2119,SC2206,SC2068
########################################################################
echo '
            █░░ █ █▄░█ █░█ ▀▄▀ ▄▄ █▀▀ ▄▀█ █▀▄▀█ █ █▄░█ █▀▀ ░ █▀█ █░█
            █▄▄ █ █░▀█ █▄█ █░█ ░░ █▄█ █▀█ █░▀░█ █ █░▀█ █▄█ ▄ █▀▄ █▄█

██████╗░░█████╗░██████╗░████████╗██████╗░██████╗░░█████╗░████████╗░█████╗░███╗░░██╗
██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗████╗░██║
██████╔╝██║░░██║██████╔╝░░░██║░░░██████╔╝██████╔╝██║░░██║░░░██║░░░██║░░██║██╔██╗██║
██╔═══╝░██║░░██║██╔══██╗░░░██║░░░██╔═══╝░██╔══██╗██║░░██║░░░██║░░░██║░░██║██║╚████║
██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░░░░██║░░██║╚█████╔╝░░░██║░░░╚█████╔╝██║░╚███║
╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░░╚════╝░╚═╝░░╚══╝
'

$PW_DEBUG

if [[ $(id -u) = 0 ]] \
&& [[ ! -e "/userdata/system/batocera.conf" ]]
then
    echo "Do not run this script as root!"
    exit 1
fi

if PORT_SCRIPTS_PATH=$(readlink -f "${0%/*}") ; then
    export PORT_SCRIPTS_PATH
    export PORT_WINE_PATH=${PORT_SCRIPTS_PATH%/*/*}
else
    echo "The PORT_SCRIPTS_PATH directory was not found!"
    exit 1
fi

# shellcheck source=/dev/null
source "$PORT_SCRIPTS_PATH/functions_helper"

export PW_START_PID="$$"
export NO_AT_BRIDGE="1"
export GDK_BACKEND="x11"
export pw_full_command_line=("$0" $*)
export orig_IFS="$IFS"

MISSING_DESKTOP_FILE="0"

unset PW_NO_RESTART_PPDB PW_DISABLED_CREATE_DB

if [[ "$1" == *.[Pp][Pp][Aa][Cc][Kk] ]] ; then
    export PW_NO_RESTART_PPDB="1"
    export PW_DISABLED_CREATE_DB="1"
    portwine_exe="$1"
elif [[ -f "$1" ]] ; then
    portwine_exe="$(realpath -s "$1")"
elif [[ -f "$OLDPWD/$1" ]] \
&& [[ "$1" == *.[Ee][Xx][Ee] || "$1" == *.[Bb][Aa][Tt] || "$1" == *.[Rr][Ee][Gg] || "$1" == *.[Mm][Ss][Ii] ]]
then
    portwine_exe="$(realpath -s "$OLDPWD/$1")"
elif [[ "$1" == "--debug" ]] \
&& [[ -f "$2" ]]
then
    portwine_exe="$(realpath -s "$2")"
elif [[ "$1" == "--debug" ]] \
&& [[ -f "$OLDPWD/$2" ]] \
&& [[ "$2" == *.[Ee][Xx][Ee] || "$2" == *.[Bb][Aa][Tt] || "$2" == *.[Rr][Ee][Gg] || "$2" == *.[Mm][Ss][Ii] ]]
then
    portwine_exe="$(realpath -s "$OLDPWD/$2")"
elif [[ "$1" == *.[Ee][Xx][Ee] || "$1" == *.[Bb][Aa][Tt] || "$1" == *.[Mm][Ss][Ii] || "$1" == *.[Rr][Ee][Gg] ]]
then
    portwine_exe="$1"
    MISSING_DESKTOP_FILE="1"
fi
export portwine_exe

# HOTFIX - ModernWarships
if echo "$portwine_exe" | grep ModernWarships &>/dev/null \
&& [[ -f "$(dirname "${portwine_exe}")/Modern Warships.exe" ]]
then
    portwine_exe="$(dirname "${portwine_exe}")/Modern Warships.exe"
    export portwine_exe
    MISSING_DESKTOP_FILE="0"
fi

create_new_dir "${HOME}/.local/share/applications"
if [[ "${PW_SILENT_RESTART}" == "1" ]] \
|| [[ "${START_FROM_STEAM}" == "1" ]]
then
    export PW_GUI_DISABLED_CS="1"
    unset PW_SILENT_RESTART
else
    unset PW_GUI_DISABLED_CS
fi

unset MANGOHUD MANGOHUD_DLSYM PW_NO_ESYNC PW_NO_FSYNC PW_VULKAN_USE WINEDLLOVERRIDES PW_NO_WRITE_WATCH PW_YAD_SET PW_ICON_FOR_YAD
unset PW_CHECK_AUTOINSTALL PW_VKBASALT_EFFECTS PW_VKBASALT_FFX_CAS PORTWINE_DB PORTWINE_DB_FILE RADV_PERFTEST
unset CHK_SYMLINK_FILE PW_MESA_GL_VERSION_OVERRIDE PW_VKD3D_FEATURE_LEVEL PATH_TO_GAME PW_START_DEBUG PORTPROTON_NAME PW_PATH
unset PW_PREFIX_NAME WINEPREFIX VULKAN_MOD PW_WINE_VER PW_ADD_TO_ARGS_IN_RUNTIME PW_GAMEMODERUN_SLR AMD_VULKAN_ICD PW_WINE_CPU_TOPOLOGY
unset MANGOHUD_CONFIG FPS_LIMIT PW_WINE_USE WINEDLLPATH WINE WINEDIR WINELOADER WINESERVER PW_USE_RUNTIME PORTWINE_CREATE_SHORTCUT_NAME MIRROR
unset PW_LOCALE_SELECT PW_SETTINGS_INDICATION PW_GUI_START PW_AUTOINSTALL_EXE NOSTSTDIR RADV_DEBUG PW_NO_AUTO_CREATE_SHORTCUT
unset PW_NAME_D_ICON PW_ICON_PATH PW_GAME_TIME PW_ALL_DF PW_AMOUNT_NEW_DESKTOP PW_AMOUNT_OLD_DESKTOP PW_DESKTOP_FILES
unset AI_TYPE AI_NAME AI_IMAGE AI_INFO AI_FILE_ARRAY AI_TRUE_FILE AI_FILE_UNSORTED AI_FILE_SORTED PW_GENERATE_BUTTONS
unset PW_DESKTOP_FILES_REGEX PW_TERM PW_EXEC_FROM_DESKTOP

export PORT_WINE_TMP_PATH="${PORT_WINE_PATH}/data/tmp"
rm -f "$PORT_WINE_TMP_PATH"/*{exe,msi,tar}*

if mkdir -p "/tmp/PortProton" ; then
    export PW_TMPFS_PATH="/tmp/PortProton"
else
    create_new_dir "${PORT_WINE_PATH}/data/tmp/PortProton"
    export PW_TMPFS_PATH="${PORT_WINE_PATH}/data/tmp/PortProton"
fi

echo "" > "${PW_TMPFS_PATH}/tmp_yad_form"
echo "" > "${PW_TMPFS_PATH}/tmp_yad_form_vulkan"

create_new_dir "${PORT_WINE_PATH}/data/dist"
pushd "${PORT_WINE_PATH}/data/dist/" 1>/dev/null || fatal
for dist_dir in ./* ; do
    [[ -d "$dist_dir" ]] || continue
    dist_dir_new="${dist_dir//[[:blank:]]/_}"
    if [[ ! -d "${PORT_WINE_PATH}/data/dist/${dist_dir_new^^}" ]] ; then
        mv -- "${PORT_WINE_PATH}/data/dist/$dist_dir" "${PORT_WINE_PATH}/data/dist/${dist_dir_new^^}"
    fi
done
popd 1>/dev/null || fatal

create_new_dir "${PORT_WINE_PATH}/data/prefixes/DEFAULT"
create_new_dir "${PORT_WINE_PATH}/data/prefixes/DOTNET"
create_new_dir "${PORT_WINE_PATH}/data/prefixes/PROGRAMS"
try_force_link_dir "${PORT_WINE_PATH}/data/prefixes" "${PORT_WINE_PATH}"

pushd "${PORT_WINE_PATH}/data/prefixes/" 1>/dev/null || fatal
for pfx_dir in ./* ; do
    [[ -d "$pfx_dir" ]] || continue
    pfx_dir_new="${pfx_dir//[[:blank:]]/_}"
    if [[ ! -d "${PORT_WINE_PATH}/data/prefixes/${pfx_dir_new^^}" ]] ; then
        mv -- "${PORT_WINE_PATH}/data/prefixes/$pfx_dir" "${PORT_WINE_PATH}/data/prefixes/${pfx_dir_new^^}"
    fi
done
popd 1>/dev/null || fatal

create_new_dir "${PORT_WINE_TMP_PATH}"/gecko
create_new_dir "${PORT_WINE_TMP_PATH}"/mono

export PW_VULKAN_DIR="${PORT_WINE_TMP_PATH}/VULKAN"
create_new_dir "${PW_VULKAN_DIR}"

cd "${PORT_SCRIPTS_PATH}" || fatal

# shellcheck source=/dev/null
source "${PORT_SCRIPTS_PATH}/var"

export STEAM_SCRIPTS="${PORT_WINE_PATH}/steam_scripts"
export PW_PLUGINS_PATH="${PORT_WINE_TMP_PATH}/plugins${PW_PLUGINS_VER}"
export PW_CACHE_LANG_PATH="${PORT_WINE_TMP_PATH}/cache_lang/"
export PW_GUI_ICON_PATH="${PORT_WINE_PATH}/data/img/gui"
export PW_GUI_THEMES_PATH="${PORT_WINE_PATH}/data/themes"
export pw_yad="${PW_GUI_THEMES_PATH}/gui/yad_gui_pp"

change_locale

export urlg="https://linux-gaming.ru/portproton/"
export url_cloud="https://cloud.linux-gaming.ru/portproton"
export url_git="https://git.linux-gaming.ru/CastroFidel/PortWINE"
export PW_WINELIB="${PORT_WINE_TMP_PATH}/libs${PW_LIBS_VER}"
try_remove_dir "${PW_WINELIB}/var"
install_ver="$(<"${PORT_WINE_TMP_PATH}/PortProton_ver")"
export install_ver
scripts_install_ver="$(<"${PORT_WINE_TMP_PATH}/scripts_ver")"
export scripts_install_ver
export WINETRICKS_DOWNLOADER="curl"
export USER_CONF="${PORT_WINE_PATH}/data/user.conf"
check_user_conf
sed -i 's/="CDN"/="CLOUD"/g' "$USER_CONF"

check_variables PW_LOG "0"

try_remove_file "${PW_TMPFS_PATH}/update_pfx_log"

# shellcheck source=/dev/null
source "${USER_CONF}"

if [[ ! -f "${PW_CACHE_LANG_PATH}/$LANGUAGE" ]] ; then
    create_translations
fi

unset translations
# shellcheck source=/dev/null
source "${PW_CACHE_LANG_PATH}/$LANGUAGE"

if [[ $TRANSLATIONS_VER != "$scripts_install_ver" ]] ; then
    try_remove_dir "${PW_CACHE_LANG_PATH}"
    create_translations
    # shellcheck source=/dev/null
    source "${PW_CACHE_LANG_PATH}/$LANGUAGE"
fi

# check PortProton theme
if [[ -n "$GUI_THEME" ]] \
&& [[ -f "$PW_GUI_THEMES_PATH/$GUI_THEME.pptheme" ]]
then
    # shellcheck source=/dev/null
    source "$PW_GUI_THEMES_PATH/$GUI_THEME.pptheme"
else
    # shellcheck source=/dev/null
    source "$PW_GUI_THEMES_PATH/default.pptheme"
    echo 'export GUI_THEME="default"' >> "$USER_CONF"
fi
export YAD_OPTIONS+="--center"

# choose branch
if [[ -z "$BRANCH" ]] ; then
    echo 'export BRANCH="master"' >> "$USER_CONF"
    export BRANCH="master"
fi
if [[ "$BRANCH" == "master" ]] ; then
    print_info "Branch in used: STABLE\n"
    export BRANCH_VERSION=""
else
    print_warning "Branch in used: DEVEL\n"
    export BRANCH_VERSION="-dev"
fi

# choose mirror
if [[ -z "$MIRROR" ]] \
&& [[ "$LANGUAGE" == "ru" ]] \
&& [[ "$BRANCH" != "devel" ]]
then
    echo 'export MIRROR="CLOUD"' >> "$USER_CONF"
    MIRROR="CLOUD"
elif [[ -z "$MIRROR" ]] ; then
    echo 'export MIRROR="GITHUB"' >> "$USER_CONF"
    MIRROR="GITHUB"
fi
export MIRROR
print_info "The first mirror in used: $MIRROR\n"

# choose downloading covers from SteamGridDB or not
if [[ -z "$DOWNLOAD_STEAM_GRID" ]] ; then
    echo 'export DOWNLOAD_STEAM_GRID="1"' >> "$USER_CONF"
    export DOWNLOAD_STEAM_GRID="1"
fi

if [[ "${INSTALLING_PORT}" == 1 ]] ; then
    return 0
fi

# choose gui start
case "$PW_GUI_START" in
    PANED|NOTEBOOK) : ;;
    *)
              sed -i '/export PW_GUI_START=/d' "$USER_CONF"
              echo 'export PW_GUI_START="NOTEBOOK"' >> "$USER_CONF"
              export PW_GUI_START="NOTEBOOK"
              ;;
esac

if check_flatpak ; then
    if check_gamescope_session
    then PW_TERM="env LANG=C xterm -fullscreen -bg black -fg white -e"
    else PW_TERM="env LANG=C xterm -bg black -fg white -e"
    fi
fi

pw_check_and_download_plugins

# check skip update
if [[ "${SKIP_CHECK_UPDATES}" != 1 ]] ; then
    pw_port_update

    PW_FILESYSTEM=$(stat -f -c %T "${PORT_WINE_PATH}")
    export PW_FILESYSTEM

    background_pid --start "pw_get_tmp_files" "1"
fi

# create lock file
if ! check_flatpak ; then
    if [[ -f "${PW_TMPFS_PATH}/portproton.lock" ]] ; then
        print_warning "Found lock file: ${PW_TMPFS_PATH}/portproton.lock"
        yad_question "${translations[A running PortProton session was detected.\\nDo you want to end the previous session?]}" || exit 0
    fi
    touch "${PW_TMPFS_PATH}/portproton.lock"
    rm_lock_file () {
        echo "Removing the lock file..."
        rm -fv "${PW_TMPFS_PATH}/portproton.lock" && echo "OK"
    }
    trap "rm_lock_file" EXIT
fi

if check_flatpak ; then
    try_remove_dir "${PORT_WINE_TMP_PATH}/libs${PW_LIBS_VER}"
else pw_download_libs
fi

pw_init_db

if [[ ! -d "${HOME}/PortProton" ]] \
&& check_flatpak 
then
    ln -s "${PORT_WINE_PATH}" "${HOME}/PortProton"
fi

pw_check_and_download_dxvk_and_vkd3d

# shellcheck source=/dev/null
source "${USER_CONF}"

if [[ "${SKIP_CHECK_UPDATES}" != 1 ]] ; then
    kill_portwine
    killall -15 yad_gui_pp 2>/dev/null
    kill -TERM "$(pgrep -a yad | grep PortProton | head -n 1 | awk '{print $1}')" 2>/dev/null

    if [[ -f "/usr/bin/portproton" ]] \
    && [[ -f "${HOME}/.local/share/applications/PortProton.desktop" ]]
    then
        rm -f "${HOME}/.local/share/applications/PortProton.desktop"
    fi

    if grep "SteamOS" "/etc/os-release" &>/dev/null \
    && [[ ! -f  "${HOME}/.local/share/applications/PortProton.desktop" ]]
    then
        cp -f "${PORT_WINE_PATH}/PortProton.desktop" "${HOME}/.local/share/applications/"
        update-desktop-database -q "${HOME}/.local/share/applications"
    fi
fi

export SKIP_CHECK_UPDATES="1"

[[ "$MISSING_DESKTOP_FILE" == "1" ]] && portwine_missing_shortcut

if [[ $(basename "${portwine_exe}") =~ .[Pp][Pp][Aa][Cc][Kk]$ ]] ; then
    unset PW_SANDBOX_HOME_PATH
    pw_init_runtime
    if check_flatpak
    then TMP_ALL_PATH=""
    else TMP_ALL_PATH="LD_LIBRARY_PATH=\"${PW_LD_LIBRARY_PATH}\""
    fi
    PW_PREFIX_NAME=$(basename "$1" | awk -F'.' '{print $1}')
cat << EOF > "${PORT_WINE_TMP_PATH}"/pp_pfx_unpack.sh
    #!/usr/bin/env bash
    ${TMP_ALL_PATH} unsquashfs -f -d "${PORT_WINE_PATH}/data/prefixes/${PW_PREFIX_NAME}" "$1" \
    || echo "ERROR" > "${PORT_WINE_TMP_PATH}"/pp_pfx_unpack_error
EOF
    chmod u+x "${PORT_WINE_TMP_PATH}"/pp_pfx_unpack.sh
    ${pw_runtime} ${PW_TERM} "${PORT_WINE_TMP_PATH}"/pp_pfx_unpack.sh
    if grep "ERROR" "${PORT_WINE_TMP_PATH}"/pp_pfx_unpack_error &>/dev/null ; then
        try_remove_file "${PORT_WINE_TMP_PATH}"/pp_pfx_unpack_error
        try_remove_file "${PORT_WINE_TMP_PATH}"/pp_pfx_unpack.sh
        yad_error "${translations[Unpack has FAILED for prefix:]} <b>\"${PW_PREFIX_NAME}\"</b>."
        exit 1
    else
        try_remove_file "${PORT_WINE_TMP_PATH}"/pp_pfx_unpack.sh
        if [[ -f "${PORT_WINE_PATH}/data/prefixes/${PW_PREFIX_NAME}/.create_shortcut" ]] ; then
            while IFS= read -r line
            do
                export portwine_exe="$PORT_WINE_PATH/data/prefixes/$PW_PREFIX_NAME/$line"
                portwine_create_shortcut
            done < "$PORT_WINE_PATH/data/prefixes/$PW_PREFIX_NAME/.create_shortcut"
        fi
        yad_info "${translations[Unpack is DONE for prefix:]} <b>\"${PW_PREFIX_NAME}\"</b>."
        exit 0
    fi
fi

### CLI ###

case "${1}" in
    '--help' )
        files_from_autoinstall=$(ls "${PORT_SCRIPTS_PATH}/pw_autoinstall")
        echo -e "
use: [--repair] [--reinstall] [--autoinstall]

--repair                                            forces all scripts to be updated to a working state
                                                    (helps if PortProton is not working)
--reinstall                                         reinstall files of the portproton to default settings
--autoinstall [script_frome_pw_autoinstall]         autoinstall from the list below:
"
        echo ${files_from_autoinstall}

        echo "
--generate-pot                                      generated pot file
"
        echo "
--debug                                             debug scripts for PortProton
                                                    (saved log in $PORT_WINE_PATH/scripts-debug.log)
"
        echo "
--update                                            check update scripts for PortProton
"
        exit 0 ;;

    '--reinstall' )
        export PW_REINSTALL_FROM_TERMINAL=1
        pw_reinstall_pp ;;

    '--autoinstall' )
        export PW_YAD_SET="$2"
        pw_autoinstall_from_db
        exit 0 ;;

    '--generate-pot' )
        generate_pot
        exit 0 ;;

    '--debug' )
        clear
        export PW_DEBUG="set -x"
        /usr/bin/env bash -c ${pw_full_command_line[@]} 2>&1 | tee "$PORT_WINE_PATH/scripts-debug.log" &
        exit 0 ;;

    '--server-file-access' )
        echo
        curl -s --list-only "https://cloud.linux-gaming.ru/log/$(date +20%y_%m)_file_access.log" | sort -V -k 2,2 \
        | sed 's/count=//g' | awk '{a=$1; $1=$2; $2=a} 1' | awk 'BEGIN {print "Count: Name:"} {print}' | column -t
        echo
        exit 0 ;;

    '--update' )
        gui_pw_update ;;
esac

### GUI ###

unset PW_ADD_PREFIXES_TO_GUI
if [[ -d "${PORT_WINE_PATH}/data/prefixes/" ]] ; then
    PW_PREFIX_NAME="${PW_PREFIX_NAME//[[:blank:]]/_}"
    for PAIG in "${PORT_WINE_PATH}"/data/prefixes/* ; do
        if [[ "${PAIG//"${PORT_WINE_PATH}/data/prefixes/"/}" != "${PORTWINE_DB^^//[[:blank:]]/_}" ]] \
        && [[ "${PAIG//"${PORT_WINE_PATH}/data/prefixes/"/}" != "${PW_PREFIX_NAME}" ]] \
        && [[ "${PAIG//"${PORT_WINE_PATH}/data/prefixes/"/}" != "*" ]]
        then
            PW_ADD_PREFIXES_TO_GUI="${PW_ADD_PREFIXES_TO_GUI}!${PAIG//"${PORT_WINE_PATH}/data/prefixes/"/}"
        fi
    done
    PW_ADD_PREFIXES_TO_GUI="${PW_PREFIX_NAME^^}${PW_ADD_PREFIXES_TO_GUI}"
fi

unset DIST_ADD_TO_GUI
if command -v wine &>/dev/null
then DIST_ADD_TO_GUI="!USE_SYSTEM_WINE"
fi
if [[ -d "${PORT_WINE_PATH}/data/dist/" ]] ; then
    for DAIG in "${PORT_WINE_PATH}"/data/dist/* ; do
        if [[ "${DAIG//"${PORT_WINE_PATH}/data/dist/"/}" != "${PW_WINE_LG_VER}" ]] \
        && [[ "${DAIG//"${PORT_WINE_PATH}/data/dist/"/}" != "${PW_PROTON_LG_VER}" ]] \
        && [[ "${DAIG//"${PORT_WINE_PATH}/data/dist/"/}" != "*" ]]
        then
            DIST_ADD_TO_GUI="${DIST_ADD_TO_GUI}!${DAIG//"${PORT_WINE_PATH}/data/dist/"/}"
        fi
    done
fi

SORT_OPENGL="${translations[WineD3D OpenGL (For video cards without Vulkan)]}"
SORT_VULKAN="${translations[WineD3D Vulkan (Damavand experimental)]}"
SORT_LEGACY="${translations[Legacy DXVK (Vulkan v1.1)]}"
SORT_STABLE="${translations[Stable DXVK, VKD3D (Vulkan v1.2)]}"
SORT_NEWEST="${translations[Newest DXVK, VKD3D, D8VK (Vulkan v1.3+)]}"
SORT_G_NINE="${translations[Gallium Nine (DirectX 9 for MESA)]}"
SORT_G_ZINK="${translations[Gallium Zink (OpenGL to Vulkan)]}"

case "${PW_VULKAN_USE}" in
    0) PW_DEFAULT_VULKAN_USE="$SORT_OPENGL!$SORT_NEWEST!$SORT_STABLE!$SORT_LEGACY!$SORT_G_ZINK!$SORT_G_NINE!$SORT_VULKAN" ;;
    6) PW_DEFAULT_VULKAN_USE="$SORT_VULKAN!$SORT_NEWEST!$SORT_STABLE!$SORT_LEGACY!$SORT_G_ZINK!$SORT_G_NINE!$SORT_OPENGL" ;;
    1) PW_DEFAULT_VULKAN_USE="$SORT_STABLE!$SORT_NEWEST!$SORT_LEGACY!$SORT_G_ZINK!$SORT_G_NINE!$SORT_OPENGL!$SORT_VULKAN" ;;
    5) PW_DEFAULT_VULKAN_USE="$SORT_LEGACY!$SORT_NEWEST!$SORT_STABLE!$SORT_G_ZINK!$SORT_G_NINE!$SORT_OPENGL!$SORT_VULKAN" ;;
    4) PW_DEFAULT_VULKAN_USE="$SORT_G_ZINK!$SORT_NEWEST!$SORT_STABLE!$SORT_LEGACY!$SORT_G_NINE!$SORT_OPENGL!$SORT_VULKAN" ;;
    3) PW_DEFAULT_VULKAN_USE="$SORT_G_NINE!$SORT_NEWEST!$SORT_STABLE!$SORT_LEGACY!$SORT_G_ZINK!$SORT_OPENGL!$SORT_VULKAN" ;;
    *) PW_DEFAULT_VULKAN_USE="$SORT_NEWEST!$SORT_STABLE!$SORT_LEGACY!$SORT_G_ZINK!$SORT_G_NINE!$SORT_OPENGL!$SORT_VULKAN" ;;
esac

if [[ $PW_WINE_USE == PROTON_LG ]] ; then
    PW_WINE_USE="${PW_PROTON_LG_VER}"
    PW_DEFAULT_WINE_USE="${PW_WINE_LG_VER}${DIST_ADD_TO_GUI}!GET-OTHER-WINE"
elif [[ $PW_WINE_USE == WINE_*_LG ]] \
|| [[ $PW_WINE_USE == WINE_LG ]]
then
    PW_WINE_USE="${PW_WINE_LG_VER}"
    PW_DEFAULT_WINE_USE="${PW_PROTON_LG_VER}${DIST_ADD_TO_GUI}!GET-OTHER-WINE"
else
    PW_DEFAULT_WINE_USE="${PW_PROTON_LG_VER}!${PW_WINE_LG_VER}${DIST_ADD_TO_GUI}!GET-OTHER-WINE"
fi

if [[ -z "${PORTWINE_DB_FILE}" ]] ; then
    unset PW_GUI_DISABLED_CS
fi

if [[ -f "${portwine_exe}" ]] ; then
    unset TAB_MAIN_MENU
    if [[ "$RESTART_PP_USED" == "edit_db" ]] ; then
        unset RESTART_PP_USED
        gui_edit_db
    elif [[ "$RESTART_PP_USED" == "userconf" ]] ; then
        unset RESTART_PP_USED
        gui_userconf
    fi
    if [[ "${PW_GUI_DISABLED_CS}" != 1 ]] ; then
        pw_create_gui_png
        if ! grep -il "${portwine_exe}" "${HOME}/.local/share/applications"/*.desktop &>/dev/null ; then
            PW_SHORTCUT="${translations[CREATE SHORTCUT]}!$PW_GUI_ICON_PATH/$BUTTON_SIZE.png!${translations[Create shortcut for select file...]}:100"
        else
            PW_SHORTCUT="${translations[DELETE SHORTCUT]}!$PW_GUI_ICON_PATH/$BUTTON_SIZE.png!${translations[Delete shortcut for select file...]}:98"
        fi

        [[ $DESKTOP_WITH_TIME == enabled ]] && search_desktop_file
        if [[ -z "${PW_COMMENT_DB}" ]] ; then
            if [[ -n "${PORTPROTON_NAME}" ]] ; then
                PW_COMMENT_DB="${translations[Launching]} <b>$(print_wrapped "${PORTPROTON_NAME}" "50")</b>$(seconds_to_time "$TIME_CURRENT")"
            else
                PW_COMMENT_DB="${translations[Launching]} <b>$(print_wrapped "${PORTWINE_DB}" "50")</b>$(seconds_to_time "$TIME_CURRENT")"
            fi
        else
            PW_COMMENT_DB="$PW_COMMENT_DB$(seconds_to_time "$TIME_CURRENT")"
        fi

        export KEY_START="$RANDOM"
        if [[ "${PW_GUI_START}" == "NOTEBOOK" ]] ; then
            "${pw_yad}" --plug=$KEY_START --tabnum=1 --form --separator=";" ${START_GUI_TYPE} \
            --gui-type-box="${START_GUI_TYPE_BOX}" --gui-type-layout="${START_GUI_TYPE_LAYOUT_UP}" \
            --gui-type-text="${START_GUI_TYPE_TEXT}" --gui-type-images="${START_GUI_TYPE_IMAGE}" \
            --image="${PW_ICON_FOR_YAD}" --text-align="center" --text "$PW_COMMENT_DB" \
            --field="3D API  : :CB" "${PW_DEFAULT_VULKAN_USE}" \
            --field="  WINE  : :CB" "$(combobox_fix "${PW_WINE_USE}" "${PW_DEFAULT_WINE_USE}")" \
            --field="PREFIX  : :CBE" "${PW_ADD_PREFIXES_TO_GUI}" \
            1> "${PW_TMPFS_PATH}/tmp_yad_form_vulkan" 2>/dev/null &

            "${pw_yad}" --plug=$KEY_START --tabnum=2 --form --columns="${START_GUI_NOTEBOOK_COLUMNS}" --align-buttons --homogeneous-column \
            --gui-type-layout="${START_GUI_TYPE_LAYOUT_NOTEBOOK}" \
            --field="   ${translations[Base settings]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Edit database file for]} ${PORTWINE_DB}":"FBTN" '@bash -c "button_click --start 118"' \
            --field="   ${translations[Global settings]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Settings for user.conf]}":"FBTN" '@bash -c "button_click --start 128"' \
            --field="   ${translations[Open directory]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Open directory with <b>.ppdb</b> file]}":"FBTN" '@bash -c "button_click --start open_game_folder"' \
            --field="   vkBasalt"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Enable vkBasalt by default to improve graphics in games running on Vulkan. (The HOME hotkey disables vkbasalt)]}":"FBTN" '@bash -c "button_click --start 120"' \
            --field="   MangoHud"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Enable Mangohud by default (R_SHIFT + F12 keyboard shortcuts disable Mangohud)]}":"FBTN" '@bash -c "button_click --start 122"' \
            --field="   dgVoodoo2"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Enable dgVoodoo2 by default (This wrapper fixes many compatibility and rendering issues when running old games)]}":"FBTN" '@bash -c "button_click --start 124"' \
            --field="   GameScope"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Enable GameScope by default (Wayland micro compositor)]}":"FBTN" '@bash -c "button_click --start 126"' \
            2>/dev/null &

            if [[ "${PW_YAD_FORM_TAB}" == "1" ]] \
            && [[ -n "${TAB_START}" ]]
            then
                export TAB_START="2"
                unset PW_YAD_FORM_TAB
            else
                export TAB_START="1"
            fi

            "${pw_yad}" --key=$KEY_START --notebook --active-tab="${TAB_START}" \
            --gui-type="settings-notebook" \
            --width="${PW_START_SIZE_W}" --tab-pos="${PW_TAB_POSITON}" \
            --title "PortProton-${install_ver} (${scripts_install_ver}${BRANCH_VERSION})" --expand \
            --window-icon="$PW_GUI_ICON_PATH/portproton.svg" \
            --tab="${translations[GENERAL]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" \
            --tab="${translations[SETTINGS]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" \
            --button="${translations[MAIN MENU]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Main menu]}":128 \
            --button="${PW_SHORTCUT}" \
            --button="${translations[DEBUG]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Launch with the creation of a .log file at the root PortProton]}":102 \
            --button="${translations[LAUNCH]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Run file ...]}":106 2>/dev/null
            PW_YAD_SET="$?"
            export PW_YAD_FORM_TAB="1"

        elif [[ "${PW_GUI_START}" == "PANED" ]] ; then
            "${pw_yad}" --plug=$KEY_START --tabnum=1 --form --separator=";" ${START_GUI_TYPE} \
            --gui-type-box="${START_GUI_TYPE_BOX}" --gui-type-layout="${START_GUI_TYPE_LAYOUT_UP}" \
            --gui-type-text="${START_GUI_TYPE_TEXT}" --gui-type-images="${START_GUI_TYPE_IMAGE}" \
            --image="${PW_ICON_FOR_YAD}" --text-align="center" --text "$PW_COMMENT_DB" \
            --field="3D API  : :CB" "${PW_DEFAULT_VULKAN_USE}" \
            --field="  WINE  : :CB" "$(combobox_fix "${PW_WINE_USE}" "${PW_DEFAULT_WINE_USE}")" \
            --field="PREFIX  : :CBE" "${PW_ADD_PREFIXES_TO_GUI}" \
            1> "${PW_TMPFS_PATH}/tmp_yad_form_vulkan" 2>/dev/null &

            "${pw_yad}" --plug=$KEY_START --tabnum=2 --form --columns="${START_GUI_PANED_COLUMNS}" \
            --gui-type-layout="${START_GUI_TYPE_LAYOUT_PANED}" \
            --align-buttons --homogeneous-row --homogeneous-column \
            --field="   ${translations[Base settings]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Edit database file for]} ${PORTWINE_DB}":"FBTN" '@bash -c "button_click --start 118"' \
            --field="   ${translations[Global settings]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Settings for user.conf]}":"FBTN" '@bash -c "button_click --start 128"' \
            --field="   ${translations[Open directory]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Open directory with <b>.ppdb</b> file]}":"FBTN" '@bash -c "button_click --start open_game_folder"' \
            --field="   vkBasalt"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Enable vkBasalt by default to improve graphics in games running on Vulkan. (The HOME hotkey disables vkbasalt)]}":"FBTN" '@bash -c "button_click --start 120"' \
            --field="   MangoHud"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Enable Mangohud by default (R_SHIFT + F12 keyboard shortcuts disable Mangohud)]}":"FBTN" '@bash -c "button_click --start 122"' \
            --field="   dgVoodoo2"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Enable dgVoodoo2 by default (This wrapper fixes many compatibility and rendering issues when running old games)]}":"FBTN" '@bash -c "button_click --start 124"' \
            --field="   GameScope"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Enable GameScope by default (Wayland micro compositor)]}":"FBTN" '@bash -c "button_click --start 126"' \
            2>/dev/null &

            "${pw_yad}" --key=$KEY_START --paned \
            --gui-type="settings-paned" \
            --width="${PW_START_SIZE_W}" --tab-pos="${PW_TAB_POSITON}" \
            --title "PortProton-${install_ver} (${scripts_install_ver}${BRANCH_VERSION})" \
            --window-icon="$PW_GUI_ICON_PATH/portproton.svg" \
            --button="${translations[MAIN MENU]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Main menu]}":128 \
            --button="${PW_SHORTCUT}" \
            --button="${translations[DEBUG]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Launch with the creation of a .log file at the root PortProton]}":102 \
            --button="${translations[LAUNCH]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE.png"!"${translations[Run file ...]}":106 2>/dev/null
            PW_YAD_SET="$?"
        fi
        case "$PW_YAD_SET" in
            128)
                [[ "$PW_GUI_START" == "NOTEBOOK" ]] && unset PW_YAD_FORM_TAB
                PORTWINE_DB_FOR_UNSET=$(sed -n '/export/p' "${PORTWINE_DB_FILE}" | sed 's/\(export\|=.*\| \)//g')
                for db_unset in $PORTWINE_DB_FOR_UNSET ; do
                    unset "$db_unset"
                done
                unset portwine_exe KEY_START
                print_info "Restarting..."
                restart_pp
                ;;
            1|252)
                exit 0
                ;;
        esac
        pw_yad_set_form
        pw_yad_form_vulkan
    elif [[ -f "$PORTWINE_DB_FILE" ]] ; then
        portwine_launch
    fi
else
    if [[ "$RESTART_PP_USED" == "userconf" ]] ; then
        unset RESTART_PP_USED
        gui_userconf
    fi

    # Поиск .desktop файлов
    AMOUNT_GENERATE_BUTTONS="0"
    for desktop_file in "$PORT_WINE_PATH"/* ; do
        desktop_file_new="${desktop_file//"$PORT_WINE_PATH/"/}"
        if [[ $desktop_file_new =~ .desktop$ ]] ; then
            if [[ ! $desktop_file_new =~ (PortProton|readme) ]] ; then
                while IFS= read -r line ; do
                    if [[ $line =~ ^Exec= ]] ; then
                        if check_flatpak ; then
                            PW_NAME_D_ICON["$AMOUNT_GENERATE_BUTTONS"]=${line//Exec=flatpak run ru.linux_gaming.PortProton /}
                        else
                            PW_NAME_D_ICON["$AMOUNT_GENERATE_BUTTONS"]=${line//Exec=env \"$PORT_SCRIPTS_PATH\/start.sh\" /}
                        fi
                    fi
                    [[ $line =~ ^Icon= ]] && PW_ICON_PATH["$AMOUNT_GENERATE_BUTTONS"]="${line//Icon=/}"
                    [[ $line =~ ^#Time= ]] && PW_GAME_TIME["$AMOUNT_GENERATE_BUTTONS"]="${line//#Time=/}"
                    [[ $line =~ ^#NEW_DESKTOP ]] && NEW_DESKTOP=1
                done < "$desktop_file"
                PW_ALL_DF["$AMOUNT_GENERATE_BUTTONS"]="$desktop_file_new"
                if [[ $NEW_DESKTOP == 1 ]] && [[ $SORT_WITH_TIME == enabled ]] ; then
                    unset NEW_DESKTOP
                    sed -i '/^#NEW_DESKTOP/d' "$desktop_file"
                    PW_AMOUNT_NEW_DESKTOP+=($AMOUNT_GENERATE_BUTTONS)
                else
                    PW_AMOUNT_OLD_DESKTOP+=($AMOUNT_GENERATE_BUTTONS)
                fi
                # Для фикса битых #Time=
                if [[ ! ${PW_GAME_TIME["$AMOUNT_GENERATE_BUTTONS"]} =~ [0-9]+ ]] \
                || (( ${PW_GAME_TIME["$AMOUNT_GENERATE_BUTTONS"]} >= 999999999 )) ; then
                    portwine_exe=${PW_NAME_D_ICON["$AMOUNT_GENERATE_BUTTONS"]//\"/}
                    search_desktop_file
                    unset portwine_exe
                    PW_GAME_TIME["$AMOUNT_GENERATE_BUTTONS"]=${TIME_CURRENT_ARRAY[0]}
                fi
                (( AMOUNT_GENERATE_BUTTONS++ ))
            fi
        fi
    done

    # Переопределение элементов в массивах в зависимости от PW_GAME_TIME, от большего значения к меньшему.
    # 10 миллисекунд на 40 .desktop файлов, работает быстро
    if [[ $SORT_WITH_TIME == enabled ]] ; then
        for i in "${!PW_GAME_TIME[@]}" ; do
            for j in "${!PW_GAME_TIME[@]}" ; do
                if (( ${PW_GAME_TIME[$i]} > ${PW_GAME_TIME[$j]} )) \
                && [[ ! ${PW_AMOUNT_NEW_DESKTOP[*]} =~ $j ]] ; then
                    tmp_0=${PW_GAME_TIME[$i]}
                    tmp_1=${PW_ALL_DF[$i]}
                    tmp_2=${PW_NAME_D_ICON[$i]}
                    tmp_4=${PW_ICON_PATH[$i]}

                    PW_GAME_TIME[i]=${PW_GAME_TIME[$j]}
                    PW_ALL_DF[i]=${PW_ALL_DF[$j]}
                    PW_NAME_D_ICON[i]=${PW_NAME_D_ICON[$j]}
                    PW_ICON_PATH[i]=${PW_ICON_PATH[$j]}

                    PW_GAME_TIME[j]=$tmp_0
                    PW_ALL_DF[j]=$tmp_1
                    PW_NAME_D_ICON[j]=$tmp_2
                    PW_ICON_PATH[j]=$tmp_4
                fi
            done
        done
    fi

    # Генерация .desktop баттанов для главного меню
    IFS=$'\n'
    PW_GENERATE_BUTTONS="--field=   ${translations[Create shortcut...]}!${PW_GUI_ICON_PATH}/find_48.svg!:FBTNR%@bash -c \"button_click --normal pw_find_exe\"%"
    for dp in ${PW_AMOUNT_NEW_DESKTOP[@]} ${PW_AMOUNT_OLD_DESKTOP[@]} ; do
        PW_NAME_D_ICON_48="${PW_ICON_PATH[dp]%.png}_48"
        PW_NAME_D_ICON_128="${PW_ICON_PATH[dp]%.png}"
        PW_NAME_D_ICON_NEW="${PW_NAME_D_ICON[dp]//\"/}"
        resize_png "$PW_NAME_D_ICON_NEW" "${PW_NAME_D_ICON_48//"${PORT_WINE_PATH}/data/img/"/}" "48"
        resize_png "$PW_NAME_D_ICON_NEW" "${PW_NAME_D_ICON_128//"${PORT_WINE_PATH}/data/img/"/}" "128"

        PW_DESKTOP_FILES="${PW_ALL_DF[$dp]}"
        PW_DESKTOP_FILES_SHOW="$PW_DESKTOP_FILES"
        if [[ $PW_DESKTOP_FILES =~ [\(\)\!\$\%\&\`\'\"\>\<\\\|\;] ]] ; then
            PW_DESKTOP_FILES_SHOW_REGEX=(\! % \$ \& \<)
            PW_DESKTOP_FILES_REGEX=(\( \) \! \$ % \& \` \' \" \> \< \\ \| \;)

            for i in "${PW_DESKTOP_FILES_SHOW_REGEX[@]}" ; do
                PW_DESKTOP_FILES_SHOW="${PW_DESKTOP_FILES_SHOW//$i/}"
            done

            count=1
            for j in "${PW_DESKTOP_FILES_REGEX[@]}" ; do
                PW_DESKTOP_FILES="${PW_DESKTOP_FILES//$j/#+_$count#}"
                (( count++ ))
            done
        fi
        PW_GENERATE_BUTTONS+="--field=   $(print_wrapped "${PW_DESKTOP_FILES_SHOW//".desktop"/""}" "25" "...")!${PW_NAME_D_ICON_48}.png!:FBTNR%@bash -c \"button_click --desktop "${PW_DESKTOP_FILES// /#@_@#}"\"%"
    done

    MAIN_GUI_ROWS="$(( ( AMOUNT_GENERATE_BUTTONS + 1 ) / MAIN_GUI_COLUMNS + 1 ))"

    if [[ -z $PW_DESKTOP_FILES ]]
    then export PW_GUI_SORT_TABS=(1 2 3 4 5)
    else export PW_GUI_SORT_TABS=(2 3 4 5 1)
    fi

    KEY_MENU="$RANDOM"

    IFS="%"
    "${pw_yad}" --plug=$KEY_MENU --tabnum="${PW_GUI_SORT_TABS[4]}" --form --columns="$MAIN_GUI_ROWS" --homogeneous-column \
    --gui-type-layout="${MAIN_MENU_GUI_TYPE_LAYOUT}" \
    --align-buttons --scroll --separator=" " ${PW_GENERATE_BUTTONS} 2>/dev/null &
    IFS="$orig_IFS"
    unset PW_GENERATE_BUTTONS

    "${pw_yad}" --plug=$KEY_MENU --tabnum="${PW_GUI_SORT_TABS[3]}" --form --columns=3 --align-buttons --separator=";" --homogeneous-column \
    --gui-type-layout="${MAIN_MENU_GUI_TYPE_LAYOUT}" \
    --field="   ${translations[Reinstall PortProton]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"":"FBTN" '@bash -c "button_click --normal gui_pw_reinstall_pp"' \
    --field="   ${translations[Remove PortProton]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"":"FBTN" '@bash -c "button_click --normal gui_rm_portproton"' \
    --field="   ${translations[Update PortProton]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"":"FBTN" '@bash -c "button_click --normal gui_pw_update"' \
    --field="   ${translations[Changelog]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"":"FBTN" '@bash -c "button_click --normal open_changelog"' \
    --field="   ${translations[Change language]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"":"FBTN" '@bash -c "button_click --normal change_loc"' \
    --field="   ${translations[Global settings (user.conf)]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"":"FBTN" '@bash -c "button_click --normal 128"' \
    --field="   ${translations[Scripts from backup]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"":"FBTN" '@bash -c "button_click --normal gui_open_scripts_from_backup"' \
    --field="   Xterm"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"":"FBTN" '@bash -c "button_click --normal pw_start_cont_xterm"' \
    --field="   ${translations[Credits]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"":"FBTN" '@bash -c "button_click --normal gui_credits"' \
    2>/dev/null &

    "${pw_yad}" --plug=$KEY_MENU --tabnum="${PW_GUI_SORT_TABS[2]}" --form --columns=3 --align-buttons --separator=";" \
    --gui-type-layout="${MAIN_MENU_GUI_TYPE_LAYOUT}" \
    --field="   3D API  : :CB" "${PW_DEFAULT_VULKAN_USE}" \
    --field="   PREFIX  : :CBE" "${PW_ADD_PREFIXES_TO_GUI}" \
    --field="     WINE  : :CB" "$(combobox_fix "${PW_WINE_USE}" "${PW_DEFAULT_WINE_USE}")" \
    --field="${translations[Create prefix backup]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"":"CFBTN" '@bash -c "button_click --normal pw_create_prefix_backup"' \
    --field="   Winetricks"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"${translations[Run winetricks to install additional libraries to the selected prefix]}":"FBTN" '@bash -c "button_click --normal WINETRICKS"' \
    --field="   ${translations[Clear prefix]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"${translations[Clear the prefix to fix problems]}":"FBTN" '@bash -c "button_click --normal gui_clear_pfx"' \
    --field="   ${translations[Get other Wine]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"${translations[Open the menu to download other versions of WINE or PROTON]}":"FBTN" '@bash -c "button_click --normal gui_proton_downloader"' \
    --field="   ${translations[Uninstaller]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"${translations[Run the program uninstaller built into wine]}":"FBTN" '@bash -c "button_click --normal gui_wine_uninstaller"' \
    --field="   ${translations[Prefix Manager]}     "!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"${translations[Run winecfg to edit the settings of the selected prefix]}":"FBTN" '@bash -c "button_click --normal WINECFG"' \
    --field="   ${translations[File Manager]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"${translations[Run wine file manager]}":"FBTN" '@bash -c "button_click --normal WINEFILE"' \
    --field="   ${translations[Command line]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"${translations[Run wine cmd]}":"FBTN" '@bash -c "button_click --normal WINECMD"' \
    --field="   ${translations[Regedit]}"!"$PW_GUI_ICON_PATH/$BUTTON_SIZE_MM.png"!"${translations[Run wine regedit]}":"FBTN" '@bash -c "button_click --normal WINEREG"' 1> "${PW_TMPFS_PATH}/tmp_yad_form_vulkan" 2>/dev/null &

    if [[ $AI_SKIP != 1 ]] ; then
        # AI_TOP_GAMES используется для сортировки автоинсталлов (работает на эмуляторы тоже)
        AI_AMOUNT_GAMES="0" && AI_AMOUNT_EMULS="0" && AI_AMOUNT_ARRAY="0"
        for ai_file in "$PORT_SCRIPTS_PATH"/pw_autoinstall/* ; do
            while IFS= read -r line ; do
                [[ $line =~ "##########" ]] && break
                [[ $line =~ "# type: " ]] && AI_TYPE["$AI_AMOUNT_ARRAY"]="${line//# type: /}"
                [[ $line =~ "# name: " ]] && AI_NAME["$AI_AMOUNT_ARRAY"]="${line//# name: /}"
                [[ $line =~ "# image: " ]] && AI_IMAGE["$AI_AMOUNT_ARRAY"]="${line//# image: /}"
                if [[ "$LANGUAGE" == ru ]] ; then
                    [[ $line =~ "# info_ru: " ]] && AI_INFO["$AI_AMOUNT_ARRAY"]="${line//# info_ru: /}"
                else
                    [[ $line =~ "# info_en: " ]] && AI_INFO["$AI_AMOUNT_ARRAY"]="${line//# info_en: /}"
                fi
            done < "$ai_file"
            AI_FILE="${ai_file//"$PORT_SCRIPTS_PATH/pw_autoinstall/"/}"
            AI_FILE_CHECK="$AI_FILE=$AI_AMOUNT_ARRAY"
            AI_FILE_ARRAY+=($AI_FILE)
            if [[ $AI_TOP_GAMES =~ ${AI_FILE_CHECK//=*/} ]] ; then
                AI_TRUE_FILE+=($AI_FILE_CHECK)
            else
                AI_FILE_UNSORTED+=($AI_AMOUNT_ARRAY)
            fi
            (( AI_AMOUNT_ARRAY++ ))
        done

        for ai_sort in $AI_TOP_GAMES ; do
            if [[ ${AI_TRUE_FILE[*]} =~ $ai_sort ]] ; then
                AI_TRUE_FILE_NEW=(${AI_TRUE_FILE[@]//$ai_sort=/})
                AI_FILE_SORTED+=(${AI_TRUE_FILE_NEW[@]//*=*/})
            fi
        done

        IFS=$'\n'
        for ai in "${AI_FILE_SORTED[@]}" "${AI_FILE_UNSORTED[@]}" ; do
            case ${AI_TYPE[$ai]} in
                games)
                    export PW_GENERATE_BUTTONS_GAMES+="--field=   ${AI_NAME[$ai]}!$PW_GUI_ICON_PATH/${AI_IMAGE[$ai]}.png!${AI_INFO[$ai]}:FBTNR%@bash -c \"button_click --normal ${AI_FILE_ARRAY[$ai]}\"%"
                    (( AI_AMOUNT_GAMES++ ))
                    ;;
                emulators)
                    export PW_GENERATE_BUTTONS_EMULS+="--field=   ${AI_NAME[$ai]}!$PW_GUI_ICON_PATH/${AI_IMAGE[$ai]}.png!${AI_INFO[$ai]}:FBTNR%@bash -c \"button_click --normal ${AI_FILE_ARRAY[$ai]}\"%"
                    (( AI_AMOUNT_EMULS++ ))
                    ;;
                *)
                    yad_error "Line: \"type\" not found in file ${AI_FILE_ARRAY[$ai]} or misspelled."
                    ;;
            esac
        done
        export MAIN_GUI_ROWS_GAMES="$(( AI_AMOUNT_GAMES / MAIN_GUI_COLUMNS + 1 ))"
        export MAIN_GUI_ROWS_EMULS="$(( AI_AMOUNT_EMULS / MAIN_GUI_COLUMNS + 1 ))"

        export AI_SKIP="1"
    fi

    IFS="%"
    "${pw_yad}" --plug=$KEY_MENU --tabnum="${PW_GUI_SORT_TABS[1]}" --form --columns="$MAIN_GUI_ROWS_EMULS" --align-buttons --scroll --homogeneous-column \
    --gui-type-layout="${MAIN_MENU_GUI_TYPE_LAYOUT}" --separator=" " ${PW_GENERATE_BUTTONS_EMULS} 2>/dev/null &
    "${pw_yad}" --plug=$KEY_MENU --tabnum="${PW_GUI_SORT_TABS[0]}" --form --columns="$MAIN_GUI_ROWS_GAMES" --align-buttons --scroll --homogeneous-column \
    --gui-type-layout="${MAIN_MENU_GUI_TYPE_LAYOUT}" --separator=" " ${PW_GENERATE_BUTTONS_GAMES} 2>/dev/null &
    IFS="$orig_IFS"

    export START_FROM_PP_GUI="1"
    if [[ -z ${TAB_MAIN_MENU} ]] ; then
        export TAB_MAIN_MENU="1"
    fi

    if [[ -z $PW_DESKTOP_FILES ]] ; then
        "${pw_yad}" --key=$KEY_MENU --notebook --expand \
        --gui-type="settings-notebook" --active-tab="${TAB_MAIN_MENU}" \
        --width="${PW_MAIN_SIZE_W}" --height="${PW_MAIN_SIZE_H}" --no-buttons \
        --window-icon="$PW_GUI_ICON_PATH/portproton.svg" \
        --title "PortProton-${install_ver} (${scripts_install_ver}${BRANCH_VERSION})" \
        --tab-pos="bottom" \
        --tab="${translations[AUTOINSTALLS]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" \
        --tab="${translations[EMULATORS]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" \
        --tab="${translations[WINE SETTINGS]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" \
        --tab="${translations[PORTPROTON SETTINGS]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" \
        --tab="${translations[INSTALLED]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" 2>/dev/null
        YAD_STATUS="$?"
    else
        "${pw_yad}" --key=$KEY_MENU --notebook --expand \
        --gui-type="settings-notebook" --active-tab="${TAB_MAIN_MENU}" \
        --width="${PW_MAIN_SIZE_W}" --height="${PW_MAIN_SIZE_H}" --no-buttons \
        --window-icon="$PW_GUI_ICON_PATH/portproton.svg" \
        --title "PortProton-${install_ver} (${scripts_install_ver}${BRANCH_VERSION})" \
        --tab-pos="bottom" \
        --tab="${translations[INSTALLED]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" \
        --tab="${translations[AUTOINSTALLS]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" \
        --tab="${translations[EMULATORS]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" \
        --tab="${translations[WINE SETTINGS]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" \
        --tab="${translations[PORTPROTON SETTINGS]}"!"$PW_GUI_ICON_PATH/$TAB_SIZE.png"!"" 2>/dev/null
        YAD_STATUS="$?"
    fi

    if [[ "$YAD_STATUS" == "1" || "$YAD_STATUS" == "252" ]] ; then exit 0 ; fi
    pw_yad_set_form
    pw_yad_form_vulkan
    export PW_DISABLED_CREATE_DB="1"
fi

case "${VULKAN_MOD}" in
    "$SORT_OPENGL" )     export PW_VULKAN_USE="0" ;;
    "$SORT_STABLE" )     export PW_VULKAN_USE="1" ;;
    "$SORT_NEWEST" )     export PW_VULKAN_USE="2" ;;
    "$SORT_G_NINE" )     export PW_VULKAN_USE="3" ;;
    "$SORT_G_ZINK" )     export PW_VULKAN_USE="4" ;;
    "$SORT_LEGACY" )     export PW_VULKAN_USE="5" ;;
    "$SORT_VULKAN" )     export PW_VULKAN_USE="6" ;;
esac

init_wine_ver
if [[ -f "${PORTWINE_DB_FILE}" ]] ; then
    edit_db_from_gui PW_VULKAN_USE PW_WINE_USE PW_PREFIX_NAME
fi

case "$PW_YAD_SET" in
    gui_pw_reinstall_pp|open_changelog|\
    128|gui_pw_update|gui_rm_portproton|\
    change_loc|gui_open_scripts_from_backup|\
    gui_credits|pw_start_cont_xterm)
        if [[ -z $PW_DESKTOP_FILES ]] ; then
            export TAB_MAIN_MENU="4"
        else
            export TAB_MAIN_MENU="5"
        fi
        ;;
    gui_proton_downloader|WINETRICKS|\
    116|pw_create_prefix_backup|\
    gui_clear_pfx|WINEREG|WINECMD|\
    WINEFILE|WINECFG|gui_wine_uninstaller)
        if [[ -z $PW_DESKTOP_FILES ]] ; then
            export TAB_MAIN_MENU="3"
        else
            export TAB_MAIN_MENU="4"
        fi
        ;;
    pw_find_exe)
        if [[ -z $PW_DESKTOP_FILES ]] ; then
            export TAB_MAIN_MENU="5"
        else
            export TAB_MAIN_MENU="1"
        fi
        ;;
esac

case "$PW_YAD_SET" in
    98) portwine_delete_shortcut ;;
    100) portwine_create_shortcut ;;
    DEBUG|102) portwine_start_debug ;;
    106) portwine_launch ;;
    WINECFG|108) pw_winecfg ;;
    WINEFILE|110) pw_winefile ;;
    WINECMD|112) pw_winecmd ;;
    WINEREG|114) pw_winereg ;;
    WINETRICKS|116) pw_prefix_manager ;;
    gui_clear_pfx) gui_clear_pfx ;;
    gui_open_user_conf) gui_open_user_conf ;;
    gui_wine_uninstaller) gui_wine_uninstaller ;;
    gui_rm_portproton) gui_rm_portproton ;;
    gui_pw_reinstall_pp) pw_reinstall_pp ;;
    gui_pw_update) gui_pw_update ;;
    gui_proton_downloader) gui_proton_downloader ;;
    gui_open_scripts_from_backup) gui_open_scripts_from_backup ;;
    open_changelog) open_changelog ;;
    change_loc) change_loc ;;
    change_mirror) change_mirror ;;
    change_branch) change_branch ;;
    change_gui_start) change_gui_start ;;
    change_download_grid) change_download_grid ;;
    open_game_folder) open_game_folder ;;
    118) gui_edit_db ;;
    120) gui_vkbasalt ;;
    122) gui_mangohud ;;
    124) gui_dgvoodoo2 ;;
    126) gui_gamescope ;;
    128) gui_userconf ;;
    pw_create_prefix_backup) pw_create_prefix_backup ;;
    gui_credits) gui_credits ;;
    pw_start_cont_xterm) pw_start_cont_xterm ;;
    pw_find_exe) pw_find_exe ;;
    PW_*) pw_autoinstall_from_db ;;
    *.desktop) button_click --desktop ;;
    1|252|*) exit 0 ;;
esac

stop_portwine
