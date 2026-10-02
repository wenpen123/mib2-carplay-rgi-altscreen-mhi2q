Audi Virtual Cockpit CarPlay AltScreen (CN MU1003 / MHI2Q 适配版)

本项目是针对奥迪国规车机（MHI2Q_CN_AUG22_K1004 / MU1003 固件，搭载 12.3 寸全液晶虚拟座舱）编译的开箱即用 SD 卡安装文件包。

针对国内车主最常用的高德地图 / 百度地图车标偏右以及方向盘 VIEW 键切换运动模式（单圆盘）时画面被表盘遮挡/裁切的问题进行了针对性修复与实车验证。

🌟 项目来源与致谢 (Credits & Acknowledgments)
核心项目来源：mib2-carplay-rgi-altscreen

主要贡献者：Allemon

致谢：
衷心感谢 Allemon 的卓越贡献与持续维护！感谢他在 cluster-placement 分支中深入排查 AirPlay 底层的 displays session property，重构了副屏视图区域控制逻辑，并完美解决了虚拟座舱切换 Classic / Sport 视图时的视口平移问题。没有他的耐心指导与快速迭代，国内车主无法在液晶仪表上体验到如此完美的 30fps 全屏 CarPlay 导航体验。

🛠️ 主要修复与特性
高德地图 / 百度地图完美居中：
<img width="1539" height="716" alt="image" src="https://github.com/user-attachments/assets/a8ea4de4-e26d-47a7-a379-6dc17415a3c6" />
运动布局
<img width="1553" height="660" alt="image" src="https://github.com/user-attachments/assets/4b605801-a1da-4d35-8f24-c76fb27c8a39" />
<img width="1599" height="618" alt="image" src="https://github.com/user-attachments/assets/7141e626-c727-48da-b39f-7561e9e8b4a9" />
百度地图：
<img width="1569" height="618" alt="image" src="https://github.com/user-attachments/assets/738e1b5c-c31b-48c9-9116-a880b7061299" />



修复了第三方地图因忽略 iOS Safe Area 导致的画面与车标严重靠右问题。

在 GEM 绿屏菜单中将集群地图区域（Cluster map area）设置为 1080 px 后，高德地图与百度地图的车标即可处于仪表正中央，右侧多余区域平滑隐入原生车速表与引导面板后方。

方向盘 VIEW 键单双表盘适配：

修复了切换至 S/RS 运动模式（中央单炮筒大表盘）时，地图被大表盘暴力遮挡的问题。

切换至运动模式时，左侧地图小窗口自动平移并适配显示，不再挡住行车路线与车标。

固件兼容编译：

针对 MHI2Q_CN_AUG22_K1004 (MU1003) 固件 API 差异进行了变体编译（兼容 MU1003 基础库），避免了因高版本 API 缺失导致的运行异常。

📂 仓库结构说明
本仓库的内容即为 SD 卡根目录结构：


📦 安装与配置方法
1. 准备工作
   准备一张格式化为 FAT32 的 SD 卡（建议 32GB 或以下容量）。

通过 GitHub 的 Code -> Download ZIP 下载本仓库，解压后将仓库内的所有内容（包括 Toolbox/ 文件夹及校验文件）直接复制到 SD 卡的根目录下。

注意：确保 SD 卡打开后的第一级目录下直接能看到 Toolbox 文件夹，不要多嵌套一层仓库文件夹。

2. 车机安装步骤
   将 SD 卡插入车机 SD1 卡槽。

进入车机 GEM (Green Engineering Menu / 绿屏工程菜单)。

导航至：Toolbox -> Update Toolbox 执行脚本更新。

导航至：MMI-Cockpit-Carplay -> 执行 INSTALL。

安装完成后重启车机（按住三键强启或锁车断电重启）。

重启后再次进入 GEM：MMI-Cockpit-Carplay -> 执行 START。

再次重启车机。

3. 设置高德/百度地图居中（关键步骤）
   重启后进入 GEM 菜单中的 AltScreen 布局配置选项。
<img width="1584" height="848" alt="image" src="https://github.com/user-attachments/assets/d7590096-a779-4ff8-89ab-1c331599f6e2" />
进入mqbcoding-customization-mmi-cokpit-carplay 然后往下翻，找到里面的1080px 点击确定后 重新连接手机即可。
<img width="1415" height="603" alt="image" src="https://github.com/user-attachments/assets/e4d2097b-6c52-429b-839f-f13261ae2d6e" />

将 Cluster map area 设置为 1080 px (Amap/Baidu)。

重新拔插数据线 / 重连 iPhone 使 AirPlay 重新协商显示参数。

打开高德地图或百度地图巡航/导航，检查仪表盘车标已完美居中。

测试车机：
2019年出厂 B9 奥迪S4  固件版本：MHI2Q_CN_AUG22_K1004_MU1003 ，其他MHI2Q车机自行测试。

⚠️ 免责声明 (Disclaimer)
本项目提供的二进制成果仅供技术研究与车友交流使用。刷机与车机改装存在一定风险，操作前请务必确认车机固件版本，请在安全的情况下操作，注意行车安全。作者与贡献者不对任何因操作不当导致的车机故障承担责任。
