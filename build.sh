#!/bin/bash

echo "===============================Begin Build======================================"

# 微信SDK下载页面
WECHAT_DOWNLOAD_URL="https://developers.weixin.qq.com/doc/oplatform/Downloads/iOS_Resource.html"

LOCAL_WECHAT_DOWNLOAD_HTML_FILE="WechatDownload.html"

WECHAT_CONTAIN_PAY_URL=""                                               # 微信SDK url
WECHAT_CONTAIN_PAY_VERSION=""                                           # 微信SDK版本
WECHAT_CONTAIN_PAY_NAME=""                                               # 微信SDK name
LOCAL_WECHAT_CONTAIN_PAY_ZIP="Wechat_pay.zip"                           # 微信SDK压缩包名字
LOCAL_WECHAT_CONTAIN_PAY_UNZIP_DIRECTORY="Wechat_pay"                   # 微信SDK解压缩之后，文件夹名字
LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_FILE_NAME="LXWechatOpenSDK_Pay.podspec" # 微信SDK podspec文件名
LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_NAME="LXWechatOpenSDK_Pay"              # 微信SDK podspec name
LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_MODULE_NAME="WechatOpenSDK"            # 微信SDK podspec module name
LAST_LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_VERSION=""                        #本地podspec文件上次的版本号

WECHAT_NOT_CONTAIN_PAY_URL=""                                                # 微信SDK url
WECHAT_NOT_CONTAIN_PAY_VERSION=""                                            # 微信SDK版本
WECHAT_NOT_CONTAIN_PAY_NAME=""                                               # 微信SDK name
LOCAL_WECHAT_NOT_CONTAIN_PAY_ZIP="Wechat_no_pay.zip"                         # 微信SDK压缩包名字
LOCAL_WECHAT_NOT_CONTAIN_PAY_UNZIP_DIRECTORY="Wechat_no_pay"                 # 微信SDK解压缩之后，文件夹名字
LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_FILE_NAME="LXWechatOpenSDK_NoPay.podspec" # 微信SDK podspec文件名
LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_NAME="LXWechatOpenSDK_NoPay"              # 微信SDK podspec name
LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_MODULE_NAME="WechatOpenSDK"             # 微信SDK podspec module name
LAST_LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_VERSION=""                         #本地podspec文件上次的版本号

function getLocalPodVersion() {
    if [ -f "${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_FILE_NAME}" ]; then
        pattern=".*\.version.*\'.*\'.*"
        version=$(cat ${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_FILE_NAME} | grep "${pattern}")
        version="${version#*\'}" # 从左向右截取第一个'后的字符串
        version="${version%\'*}" # 从右向左截取第一个'后的字符串
        echo "获取${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_FILE_NAME}的pod版本成功，版本：${version}"
        LAST_LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_VERSION=${version}
        # echo -e "\n"
    else
        echo "${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_FILE_NAME}不存在"
        # echo -e "\n"
    fi

    if [ -f "${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_FILE_NAME}" ]; then
        pattern=".*\.version.*\'.*\'.*"
        version=$(cat ${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_FILE_NAME} | grep "${pattern}")
        version="${version#*\'}" # 从左向右截取第一个'后的字符串
        version="${version%\'*}" # 从右向左截取第一个'后的字符串
        echo "获取${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_FILE_NAME}的pod版本成功，版本：${version}"
        LAST_LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_VERSION=${version}
        # echo -e "\n"
    else
        echo "${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_FILE_NAME}不存在"
        # echo -e "\n"
    fi
}
#old 1. iOS开发工具包<a href="http://dldir1.qq.com/WechatWebDev/opensdk/OpenSDK1.9.6.zip">iOS开发工具包</a>（1.9.6版本，包含支付功能
#new 1. <a href="https://dldir1.qq.com/WechatWebDev/opensdk/OpenSDK2.0.2.zip">iOS开发工具包</a>（直接提供.a静态库文件的形式，2.0.2版本，包含支付功能）。</p> <p>2. <a href="https://dldir1.qq.com/WechatWebDev/opensdk/OpenSDK2.0.2_NoPay.zip">iOS开发工具包</a>（直接提供.a静态库文件的形式，2.0.2版本，不包含支付功能）。</p> <p>3. <a href="https://dldir1.qq.com/WechatWebDev/opensdk/XCFramework/OpenSDK2.0.2.zip">iOS开发工具包</a>（XCFramework的形式，2.0.2版本，包含支付功能）。</p> <p>4. <a href="https://dldir1.qq.com/WechatWebDev/opensdk/XCFramework/OpenSDK2.0.2_NoPay.zip">iOS开发工具包</a>（XCFramework的形式，2.0.2版本，不包含支付功能）。</p>
function getWechatProperties() {
    if [ -f "${LOCAL_WECHAT_DOWNLOAD_HTML_FILE}" ]; then
        payUrlPattern="1. <a href=\"[^<]*\">"
        pay=$(cat ${LOCAL_WECHAT_DOWNLOAD_HTML_FILE} | grep -o -E "${payUrlPattern}")
        pay="${pay#*\"}" # 从左向右截取第一个["]后的字符串
        pay="${pay%\"*}" # 从右向左截取第一个["]前的字符串
#        pay="https://dldir1.qq.com/WechatWebDev/opensdk/OpenSDK1.9.7.zip"
        echo "包含支付功能的url：${pay}"
        WECHAT_CONTAIN_PAY_URL=${pay}
        payzip="${pay#*opensdk/}" # 从左向右截取第一个[opensdk/]后的字符串
        echo "包含支付功能的zip：${payzip}"
        LOCAL_WECHAT_CONTAIN_PAY_ZIP=${payzip}
        payzip="${payzip%.*}" # 从右向左截取第一个[.]前的字符串
        echo "包含支付功能的name：${payzip}"
        WECHAT_CONTAIN_PAY_NAME=${payzip}
        
        payVersion="${payzip#OpenSDK}" # 从左向右截取第一个[OpenSDK]后的字符串
        echo "包含支付功能的版本号：${payVersion}"
        WECHAT_CONTAIN_PAY_VERSION=${payVersion}

        nopayUrlPattern="2. <a href=\"[^<]*\">"
        nopay=$(cat ${LOCAL_WECHAT_DOWNLOAD_HTML_FILE} | grep -o -E "${nopayUrlPattern}")
        nopay="${nopay#*\"}" # 从左向右截取第一个["]后的字符串
        nopay="${nopay%\"*}" # 从右向左截取第一个["]前的字符串
#        nopay="https://dldir1.qq.com/WechatWebDev/opensdk/OpenSDK1.9.7_NoPay.zip"
        echo "不包含支付功能的url：${nopay}"
        WECHAT_NOT_CONTAIN_PAY_URL=${nopay}
        nopayzip="${nopay#*opensdk/}" # 从左向右截取第一个[opensdk/]后的字符串
        echo "包含支付功能的zip：${nopayzip}"
        LOCAL_WECHAT_NOT_CONTAIN_PAY_ZIP=${nopayzip}
        nopayzip="${nopayzip%.*}" # 从右向左截取第一个[.]前的字符串
        echo "包含支付功能的name：${nopayzip}"
        WECHAT_NOT_CONTAIN_PAY_NAME=${nopayzip}

        nopayVersion="${nopayzip#OpenSDK}" # 从左向右截取第一个[OpenSDK]后的字符串
        nopayVersion="${nopayVersion%_NoPay}"    # 从右向左截取第一个[_NoPay]前的字符串
        echo "不包含支付功能的版本号：${nopayVersion}"
        WECHAT_NOT_CONTAIN_PAY_VERSION=${nopayVersion}

        # echo -e "\n"
    else
        echo "${LOCAL_WECHAT_DOWNLOAD_HTML_FILE}不存在"
        # echo -e "\n"
    fi
}

# 获取本地podspec文件的version，以便于和官方version做比较
getLocalPodVersion

# 移除压缩文件夹
rm -rf ${LOCAL_WECHAT_CONTAIN_PAY_ZIP}
rm -rf ${LOCAL_WECHAT_NOT_CONTAIN_PAY_ZIP}

# 移除解压缩文件夹
rm -rf ${LOCAL_WECHAT_CONTAIN_PAY_UNZIP_DIRECTORY}
rm -rf ${LOCAL_WECHAT_NOT_CONTAIN_PAY_UNZIP_DIRECTORY}

# 移除html
rm -rf ${LOCAL_WECHAT_DOWNLOAD_HTML_FILE}

# 下载html
curl ${WECHAT_DOWNLOAD_URL} >${LOCAL_WECHAT_DOWNLOAD_HTML_FILE}

# 获取微信官方属性（sdk下载url，sdk版本）
getWechatProperties

# 下载zip
curl "${WECHAT_CONTAIN_PAY_URL}" -o ${LOCAL_WECHAT_CONTAIN_PAY_ZIP}
curl "${WECHAT_NOT_CONTAIN_PAY_URL}" -o ${LOCAL_WECHAT_NOT_CONTAIN_PAY_ZIP}

# 解压缩zip
unzip ${LOCAL_WECHAT_CONTAIN_PAY_ZIP} -x __MACOSX/*
unzip ${LOCAL_WECHAT_NOT_CONTAIN_PAY_ZIP} -x __MACOSX/*

# 改文件夹名
mv ${WECHAT_CONTAIN_PAY_NAME} ${LOCAL_WECHAT_CONTAIN_PAY_UNZIP_DIRECTORY}
mv ${WECHAT_NOT_CONTAIN_PAY_NAME} ${LOCAL_WECHAT_NOT_CONTAIN_PAY_UNZIP_DIRECTORY}

# 移除文件夹
rm -rf ${LOCAL_WECHAT_CONTAIN_PAY_ZIP}
rm -rf ${LOCAL_WECHAT_NOT_CONTAIN_PAY_ZIP}

# 创建空文件
touch ${LOCAL_WECHAT_CONTAIN_PAY_UNZIP_DIRECTORY}/empty.swift
echo "// This is a empty swift file" >>${LOCAL_WECHAT_CONTAIN_PAY_UNZIP_DIRECTORY}/empty.swift
touch ${LOCAL_WECHAT_NOT_CONTAIN_PAY_UNZIP_DIRECTORY}/empty.swift
echo "// This is a empty swift file" >>${LOCAL_WECHAT_NOT_CONTAIN_PAY_UNZIP_DIRECTORY}/empty.swift

function makePodContainPaySpec() {
    if [ "${LAST_LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_VERSION}" != "${WECHAT_CONTAIN_PAY_VERSION}" ]; then
        if [ "${WECHAT_CONTAIN_PAY_VERSION}" == "1.9.2" ]; then
            WECHAT_CONTAIN_PAY_VERSION="1.9.2"
        fi
        echo "开始制作包含支付功能的podspec文件，版本号不相等，重新创建podspec文件"
        rm -rf ${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_FILE_NAME}
        cat <<-EOF >${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_FILE_NAME}
Pod::Spec.new do |spec|
    spec.name                   = '${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_NAME}' # 包含支付功能
    spec.version                = '${WECHAT_CONTAIN_PAY_VERSION}' # 版本号和微信的保持一致
    spec.homepage               = 'https://github.com/liuxingyx/WechatOpenSDK'
    spec.source                 = { :git => 'https://github.com/liuxingyx/WechatOpenSDK.git', :tag => spec.version }
    spec.summary                = 'WeChat SDK with payment function'
    spec.license                = { :type => 'MIT', :file => 'LICENSE' }
    spec.author                 = { 'liuxingyx' => 'lish193@163.com' }
    spec.platform               = :ios, '12.0'
    spec.ios.deployment_target  = '12.0'
    spec.module_name            = '${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_MODULE_NAME}' # 模块名和微信保持一致
    spec.requires_arc           = true
    spec.static_framework       = true
    spec.swift_version          = '5.0'
    spec.vendored_libraries     = '${LOCAL_WECHAT_CONTAIN_PAY_UNZIP_DIRECTORY}/*.a'
    spec.public_header_files    = '${LOCAL_WECHAT_CONTAIN_PAY_UNZIP_DIRECTORY}/*.h'
    spec.source_files           = '${LOCAL_WECHAT_CONTAIN_PAY_UNZIP_DIRECTORY}/*.{h,swift}'
    spec.frameworks             = 'Security', 'UIKit', 'CoreGraphics', 'WebKit'
    spec.libraries              = 'z', 'c++', 'sqlite3.0'
    spec.pod_target_xcconfig    = {
        'OTHER_LDFLAGS' => '-all_load',
        'VALID_ARCHS' => 'x86_64 armv7 arm64'
    }
end
EOF
    else
        echo "开始制作包含支付功能的podspec文件，版本号相等，不再重新创建podspec文件"
    fi
}

function makePodNotContainPaySpec() {
    if [ "${LAST_LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_VERSION}" != "${WECHAT_NOT_CONTAIN_PAY_VERSION}" ]; then
        if [ "${WECHAT_NOT_CONTAIN_PAY_VERSION}" == "1.9.2" ]; then
            WECHAT_NOT_CONTAIN_PAY_VERSION="1.9.2"
        fi
        echo "开始制作不包含支付功能的podspec文件，版本号不相等，重新创建podspec文件"
        rm -rf ${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_FILE_NAME}
        cat <<-EOF >${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_FILE_NAME}
Pod::Spec.new do |spec|
    spec.name                   = '${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_NAME}' # 不包含支付功能
    spec.version                = '${WECHAT_NOT_CONTAIN_PAY_VERSION}' # 版本号和微信的保持一致
    spec.homepage               = 'https://github.com/liuxingyx/WechatOpenSDK'
    spec.source                 = { :git => 'https://github.com/liuxingyx/WechatOpenSDK.git', :tag => spec.version }
    spec.summary                = 'WeChat SDK without payment function'
    spec.license                = { :type => 'MIT', :file => 'LICENSE' }
    spec.author                 = { 'liuxingyx' => 'lish193@163.com' }
    spec.platform               = :ios, '12.0'
    spec.ios.deployment_target  = '12.0'
    spec.module_name            = '${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_MODULE_NAME}' # 模块名和微信保持一致
    spec.requires_arc           = true
    spec.static_framework       = true
    spec.swift_version          = '5.0'
    spec.vendored_libraries     = '${LOCAL_WECHAT_NOT_CONTAIN_PAY_UNZIP_DIRECTORY}/*.a'
    spec.public_header_files    = '${LOCAL_WECHAT_NOT_CONTAIN_PAY_UNZIP_DIRECTORY}/*.h'
    spec.source_files           = '${LOCAL_WECHAT_NOT_CONTAIN_PAY_UNZIP_DIRECTORY}/*.{h,swift}'
    spec.frameworks             = 'Security', 'UIKit', 'CoreGraphics', 'WebKit'
    spec.libraries              = 'z', 'c++', 'sqlite3.0'
    spec.pod_target_xcconfig    = {
        'OTHER_LDFLAGS' => '-all_load',
        'VALID_ARCHS' => 'x86_64 armv7 arm64'
    }
end
EOF
    else
        echo "开始制作不包含支付功能的podspec文件，版本号相等，不再重新创建podspec文件"
    fi
}

# 创建podspec文件
makePodContainPaySpec
makePodNotContainPaySpec

# 输出podspec文件内容
cat ${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_FILE_NAME}
cat ${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_FILE_NAME}

echo "开始验证pod..."
pod lib lint ${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_FILE_NAME} --allow-warnings
pod lib lint ${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_FILE_NAME} --allow-warnings
echo "pod验证完毕"

echo "请手动执行pod trunk push ${LOCAL_WECHAT_CONTAIN_PAY_PODSPEC_FILE_NAME} --allow-warnings"
echo "请手动执行pod trunk push ${LOCAL_WECHAT_NOT_CONTAIN_PAY_PODSPEC_FILE_NAME} --allow-warnings"

echo "===============================End Build======================================"
