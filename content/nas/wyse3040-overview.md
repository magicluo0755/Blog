---
author : "Laurence"
title : "Dell Wyse3040软路由介绍"
date : 2024-08-19
description : "Dell Wyse3040作为软路由的新选择"
tags : [
    "OpenWRT",
]
categories : [
    "软路由",
]

toc : true
---

## 产品参数

Dell Wyse 3040 瘦客户机是一种低成本的入门级云终端瘦客户机。瘦客户机具有 x86 处理器，并允许您运行 Wyse ThinOS、启用 PCoIP 的 Wyse ThinOS 和 Wyse ThinLinux。平台通过连接到任何显示器用作瘦客户机，并允许您将远程访问客户机用于 VDI 或基于云的计算。

该小主机主要组件：

![wyse3040-component](/assets/nas/wyse3040/wyse3040-component.jpg)

1. 机箱盖
2. WLAN 卡 (部分配置没有网卡)
3. 系统板
4. 机箱
5. 币形电池
6. 散热器

Wyse3040瘦客户机做工非常精致，尺寸小巧，非常适合改装为软路由设备，其具体产品参数如下：

| 参数       | 配置说明                                                     |
| :--------- | ------------------------------------------------------------ |
| 处理器类型 | Intel(R) Atom(TM) x5-Z8350 1600MHz ，四核四线程              |
| 处理器主频 | `1.44GHz`                                                    |
| 操作系统   | -  OP R23.6.6 (默认)<br />-  Daphile 24.06<br />-  Volumio3.7.42<br />-  Windows 10 LTSC |
| 标配内存   | `2GB` RAM（焊入式）                                          |
| 标配闪存   | `8GB` emmc存储，可选择64G/128G扩容版本                       |
| 显卡芯片   | 无显卡适配器                                                 |
| 显示器描述 | 双显示器支持：2560×1600@60Hz                                 |
| 网络       | 10Mb/100MB/1Gb铜线RJ45（有线以太网）。<br />部分可选内置的无线通讯模块，符合802.11a/b/g无线协议标准 |
| I/O外设    | 3个USB 2.0端口，1个USB 3.0端口<br />1个RJ45 1Gbps，2个DisplayPort端口 ，1个复合音频插孔 |
| 产品电源   | 15W（5V，3A） AC适配器 ，耗电量≤`5W`                         |
| 产品尺寸   | 27.94×101.6×101.6mm                                          |
| 产品重量   | 0.24kg                                                       |



## 快速开始使用

介绍快速使用。

### 开箱检查
开箱检查说明，wyse3040小主机一台，外加5v3A标准电源适配器。

### 通电与连接
设备接口连接，hdmi接显示器，网口，电源线连接。

### 旁路由配置
设置电脑ip为软路由设备的网络段，wyse3040默认刷入的OP系统的ip为`192.168.1.1`，用户名`root`，密码`password`。

### 验证测试
测试使用旁路由代理上网功能。



### 访问BIOS设置

本节介绍 Wyse 3040 瘦客户机 UEFI BIOS 设置。启动瘦客户机时，Dell 徽标会显示一小会。

1. 在启动过程中，按 **F2** 键。默认密码是 Fireport

2. 通过密码保护 BIOS 设置。提示时，输入密码 Fireport。

   此时将显示**BIOS** 设置对话框。

3. 使用系统设置程序设置来更改 BIOS 设置。

> 注:在 BIOS 菜单中，有一个选项可用于恢复 BIOS 默认值、出厂默认值和用户的自定义用户设置。BIOS 默认设置可还原属于 BIOS 文件一部分的值，而还原自定义用户设置会还原为默认设置。还原出厂默认值会将 BIOS 设置还原成在交付给客户之前，在工厂中配置的值。

要在启动过程中访问引导菜单，请按 **F12** 键。使用引导选择菜单选择或查看引导顺序，如下所示：

- 从 UEFI 引导：硬盘，分区 2（对于 ThinLinux 客户端），分区 4（对于 ThinOS 客户端）- 从内部 eMMC 存储引导。
- 从 IP4 Realtek PCIe GBE 系列控制器引导 - 通过 PXE 从网络引导。
- 从 IP6 Realtek PCIe GBE 系列控制器引导 - 通过 PXE 从网络引导
- 从 USB 引导 - 从任何 USB 端口引导 USB 存储。如果插入了可引导的 USB 设备，则会显示此选项。

## 其他

wyse3040官方介绍文档

- [Dell Wyse3040瘦客户端 用户指南](https://www.dell.com/support/manuals/zh-cn/wyse-3040-thin-client/3040_ug/%E7%89%88%E6%9D%83?guid=guid-089ffa4b-3a62-4b51-bde1-309c58a451d9&lang=zh-cn)
- [Dell Wyse3040快速入门指南](/assests/pdf/wyse-3040-thin-client_setup-guide_zh-cn.pdf)



