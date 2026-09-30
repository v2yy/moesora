# moesora（v2yy 定制线）

本站博客（https://v2yy.com ，Halo 2.26 / 容器 halo2 / 卷 /opt/halo2b）所用主题的定制仓库。

- 上游：`7l4i8y1a4n3g8-7l4i8y1a4n3g8-1438-9748/moesora`（master）
- 本仓库 fork 的基线 tag：**1.1.9**（`base/moesora-1.1.9.zip` 为生产镜像里的官方主题包原件，SHA 与生产一致）
- `pristine/`：1.1.9 zip 解包后的**未改动**原版树（fork master 与之逐字节一致，已验证）
- `installed/`：从生产 VPS `/opt/halo2b/themes/moesora` rsync 回来的**线上现状快照**（2026-09-30）
- `custom/`：所有需要覆盖官方文件的定制件（升级主题后整目录重放即可）
- `patches/`：定制件相对官方的 diff，仅供审查
- `apply.sh`：对任意主题解包目录执行定制重放

## 定制清单（相对官方 1.1.9 的全部差异）

| 文件 | 类型 | 原因 |
|------|------|------|
| `custom/templates/modules/navbar.html` | 补丁 | 菜单项 `status.displayName/href` 在迁移数据未 reconcile 时为 null，Thymeleaf `#strings.contains` 直接抛 500；改为 `status.X ?: spec.X` 兜底 |
| `custom/templates/modules/drawer.html` | 补丁 | 同上（移动端抽屉导航同款问题） |
| `custom/templates/bangumis.html` | 新增 | plugin-bilibili-bangumi 路由依赖主题模板 `bangumis.html`，官方 moesora 不带 → /bangumis 404。手写 moesora 风格模板（layout 片段 + 筛选 + 分页） |
| `custom/templates/psn.html` | 新增 | PluginPsn（自研）的 PSN 游戏生涯页模板 |
| `custom/theme-settings-20260930.json` | 配置快照 | 12 个设置分组的线上值（含主题色 #f9a8d4/#5FB4E8、壁纸随机源 img.v2yy.com/random.php?album=1 等）。升级/重装主题后用后台 json-config API 重放 |

`installed/templates/modules/*.bak` 是打补丁前自动留的备份，**不入库**（gitignore 掉）。

## 升级主题后的重放流程（铁律：zip 升级会覆盖全部定制！）

```bash
# 1. 解包新主题 zip
unzip halo-theme-moesora-<ver>.zip -d new-theme/
# 2. 重放定制文件
bash apply.sh new-theme/
# 3. 上传到 VPS 卷并重启
rsync -a new-theme/ vultr:/opt/halo2b/themes/moesora/
ssh vultr docker restart halo2
# 4. 验证
curl -s -A "Mozilla/5.0" https://v2yy.com/ | grep -q "一言即诺" && echo HOME-OK
curl -s -o /dev/null -w "%{http_code}\n" -A "Mozilla/5.0" https://v2yy.com/bangumis
curl -s -o /dev/null -w "%{http_code}\n" -A "Mozilla/5.0" https://v2yy.com/psn
```

> 注：生产实际生效路径是**卷内直接改**（VPS `/opt/halo2b/themes/moesora`，由 Halo 容器读取）。
> 后台「主题包更新」zip 安装会重建目录、抹掉补丁——所以每次升级必须走上面的重放流程。

## 基线记录

| 日期 | Halo | 主题 | 定制差异 | 快照 |
|------|------|------|----------|------|
| 2026-09-30 | halohub/halo:2.26 | moesora 1.1.9 | 2 补丁 + 2 新模板 | 本仓库初始 commit |
