# 电商App开发框架

这是一个基于Flutter开发的电商App基础框架，采用**MVVM（Model-View-ViewModel）架构**设计模式，使用Riverpod进行状态管理，提供了完整的项目结构和核心功能模块。

## 架构说明

### MVVM架构

本项目采用MVVM（Model-View-ViewModel）架构模式：

- **Model（模型层）**: 数据模型和业务实体，位于 `lib/data/models/`
- **View（视图层）**: UI展示，包括页面和组件，位于 `lib/presentation/pages/` 和 `lib/presentation/widgets/`
- **ViewModel（视图模型层）**: 业务逻辑处理，使用Riverpod StateNotifier实现，位于 `lib/presentation/viewmodels/`

### 架构分层

1. **Core层**: 核心功能（路由、主题、工具类等）
2. **Data层**: 数据源和仓库实现
3. **Domain层**: 业务接口定义
4. **Presentation层**: UI和状态管理

## 项目结构

```
lib/
├── core/                    # 核心层
│   ├── constants/          # 常量定义
│   ├── theme/              # 主题配置
│   ├── router/             # 路由配置
│   ├── utils/              # 工具类
│   └── extension/          # 扩展方法
├── data/                   # 数据层
│   ├── datasources/        # 数据源（本地存储、网络请求）
│   ├── models/             # 数据模型（Model）
│   └── repositories/       # 仓库实现
├── domain/                 # 领域层
│   └── repositories/       # 仓库接口
└── presentation/           # 表现层
    ├── pages/              # 页面（View）
    ├── widgets/            # 通用组件（View）
    ├── viewmodels/         # 视图模型（ViewModel）
    └── providers/          # Provider配置
```

## 技术栈

- **Flutter**: UI框架
- **Riverpod**: 状态管理（MVVM架构的ViewModel实现）
- **GoRouter**: 路由管理
- **Dio**: 网络请求
- **SharedPreferences**: 本地存储
- **CachedNetworkImage**: 图片缓存

## MVVM架构详解

### ViewModel层

所有ViewModel都继承自`StateNotifier`，负责处理业务逻辑：

- `AuthViewModel`: 用户认证相关逻辑
- `HomeViewModel`: 首页数据管理
- `ProductListViewModel`: 商品列表管理
- `ProductDetailViewModel`: 商品详情管理
- `CategoryViewModel`: 分类页面管理
- `CartViewModel`: 购物车管理

### View层

页面组件（View）只负责UI展示和用户交互，不包含业务逻辑：

- 通过`ref.watch()`监听ViewModel状态
- 通过`ref.read()`调用ViewModel方法
- 所有数据都来自ViewModel

### Model层

数据模型定义在`lib/data/models/`，包括：
- `ProductModel`: 商品模型
- `UserModel`: 用户模型
- `CartItemModel`: 购物车商品模型
- `ApiResponse`: API响应模型

## 核心功能模块

### 1. 首页 (HomePage)
- Banner轮播图
- 分类导航
- 推荐商品列表

### 2. 分类页 (CategoryPage)
- 左侧分类列表
- 右侧商品网格

### 3. 购物车 (CartPage)
- 购物车商品列表
- 数量增减
- 结算功能

### 4. 个人中心 (ProfilePage)
- 用户信息展示
- 订单管理入口
- 其他功能入口

### 5. 商品模块
- 商品列表页 (ProductListPage)
- 商品详情页 (ProductDetailPage)

### 6. 订单模块
- 订单列表页 (OrderListPage)

### 7. 用户认证
- 登录页 (LoginPage)
- 注册页 (RegisterPage)

## 开始使用

### 1. 安装依赖

```bash
flutter pub get
```

### 2. 配置API地址

编辑 `lib/core/constants/app_constants.dart`，修改 `baseUrl` 为你的后端API地址。

### 3. 运行项目

```bash
flutter run
```

## 架构说明

### Clean Architecture

项目采用Clean Architecture（清洁架构）设计，分为三层：

1. **Domain层（领域层）**: 定义业务逻辑接口和实体模型
2. **Data层（数据层）**: 实现数据源和仓库，处理网络请求和本地存储
3. **Presentation层（表现层）**: 处理UI展示和用户交互

### 状态管理

使用Riverpod进行状态管理，所有Provider定义在 `lib/presentation/providers/app_providers.dart`。

### 路由管理

使用GoRouter进行路由管理，路由配置在 `lib/core/router/app_router.dart`。

## 下一步开发建议

1. **完善数据模型**: 根据实际API接口完善数据模型
2. **实现状态管理**: 使用Riverpod实现各个模块的状态管理
3. **完善UI组件**: 根据设计稿完善UI组件
4. **实现业务逻辑**: 完善各个页面的业务逻辑
5. **添加单元测试**: 为关键业务逻辑添加单元测试
6. **集成CI/CD**: 配置持续集成和持续部署

## 注意事项

- 目前项目中包含TODO标记，表示需要进一步完善的部分
- API请求使用的是模拟数据，需要根据实际后端接口进行调整
- 图片加载使用了占位符，需要配置实际的图片地址

## License

MIT License
