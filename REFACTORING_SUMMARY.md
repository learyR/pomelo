# 文件夹重构总结

## ✅ 已完成的工作

### 1. 创建新的文件夹结构
- ✅ `lib/models/` - 数据模型
- ✅ `lib/views/pages/` - 页面视图
- ✅ `lib/views/widgets/` - 组件视图
- ✅ `lib/viewmodels/` - ViewModel
- ✅ `lib/services/network/` - 网络服务
- ✅ `lib/services/network/interceptors/` - 拦截器
- ✅ `lib/repositories/` - 数据仓库
- ✅ `lib/utils/` - 工具类

### 2. 已移动的文件
- ✅ `lib/models/` - 所有模型文件（product_model, user_model, cart_item_model, base_state, base_viewmodel）
- ✅ `lib/utils/` - 工具类（logger_util, toast_util, validators）
- ✅ `lib/services/local_storage.dart` - 本地存储服务
- ✅ `lib/main.dart` - 已更新import路径

### 3. 需要继续迁移的文件

#### Services (网络相关)
需要将以下文件移动到 `lib/services/network/`:
- `lib/core/network/api_client.dart` → `lib/services/network/api_client.dart`
- `lib/core/network/api_define.dart` → `lib/services/network/api_define.dart`
- `lib/core/network/api_exception.dart` → `lib/services/network/api_exception.dart`
- `lib/core/network/api_response.dart` → `lib/services/network/api_response.dart`
- `lib/core/network/interceptors/auth_interceptor.dart` → `lib/services/network/interceptors/auth_interceptor.dart`
- `lib/core/network/interceptors/logging_interceptor.dart` → `lib/services/network/interceptors/logging_interceptor.dart`

#### Views
需要将以下文件移动:
- `lib/presentation/pages/auth/login_page.dart` → `lib/views/pages/auth/login_page.dart`
- `lib/presentation/widgets/*` → `lib/views/widgets/*`

#### ViewModels
需要将以下文件移动:
- `lib/presentation/viewmodels/auth_viewmodel.dart` → `lib/viewmodels/auth_viewmodel.dart`

#### Repositories
需要将以下文件移动:
- `lib/domain/repositories/user_repository.dart` → `lib/repositories/user_repository.dart`

## 📝 Import路径更新规则

### Models
```dart
// 旧
import '../../data/models/user_model.dart';
import '../../core/models/base_viewmodel.dart';

// 新
import '../models/user_model.dart';
import '../models/base_viewmodel.dart';
```

### Services
```dart
// 旧
import '../../core/network/api_client.dart';
import '../../data/datasources/local_storage.dart';

// 新
import '../services/network/api_client.dart';
import '../services/local_storage.dart';
```

### ViewModels
```dart
// 旧
import '../../presentation/viewmodels/auth_viewmodel.dart';

// 新
import '../viewmodels/auth_viewmodel.dart';
```

### Views
```dart
// 旧
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/widgets/loading_widget.dart';

// 新
import '../views/pages/auth/login_page.dart';
import '../views/widgets/loading_widget.dart';
```

### Utils
```dart
// 旧
import '../../core/utils/logger_util.dart';

// 新
import '../utils/logger_util.dart';
```

### Repositories
```dart
// 旧
import '../../domain/repositories/user_repository.dart';

// 新
import '../repositories/user_repository.dart';
```

## 🎯 新的文件夹结构（最终）

```
lib/
├── models/              # 数据模型（Model层）
│   ├── product_model.dart
│   ├── user_model.dart
│   ├── cart_item_model.dart
│   ├── base_state.dart
│   └── base_viewmodel.dart
├── views/               # 视图（View层）
│   ├── pages/          # 页面
│   │   └── auth/
│   │       └── login_page.dart
│   └── widgets/        # 组件
│       ├── loading_widget.dart
│       ├── error_widget.dart
│       └── empty_widget.dart
├── viewmodels/          # ViewModel层
│   └── auth_viewmodel.dart
├── services/            # 服务层
│   ├── network/        # 网络服务
│   │   ├── api_client.dart
│   │   ├── api_define.dart
│   │   ├── api_exception.dart
│   │   ├── api_response.dart
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       └── logging_interceptor.dart
│   └── local_storage.dart
├── repositories/        # 数据仓库层
│   └── user_repository.dart
├── utils/               # 工具类
│   ├── logger_util.dart
│   ├── toast_util.dart
│   └── validators.dart
└── core/                # 核心功能（保持不变）
    ├── constants/       # 常量
    │   └── app_constants.dart
    ├── router/          # 路由
    │   └── app_router.dart
    ├── theme/           # 主题
    │   └── app_theme.dart
    └── extension/       # 扩展方法
        └── string_extension.dart
```

## ⚠️ 注意事项

1. **所有文件移动后，需要更新import路径**
2. **移动网络服务文件时，需要更新内部的相对import路径**
3. **删除旧文件夹前，确保所有文件都已正确迁移**
4. **测试每个模块是否能正常编译**

## 🔄 下一步操作

1. 移动剩余的文件到新位置
2. 批量更新所有import路径
3. 运行 `flutter pub get` 和 `flutter analyze` 检查错误
4. 删除旧的文件夹（data/, domain/, presentation/, core/models/, core/network/, core/utils/）
5. 更新README.md文档

