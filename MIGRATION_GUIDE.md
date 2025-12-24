# 文件夹重构迁移指南

## 新的文件夹结构（Flutter官方推荐的MVVM架构）

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
└── core/                # 核心功能
    ├── constants/       # 常量
    │   └── app_constants.dart
    ├── router/          # 路由
    │   └── app_router.dart
    ├── theme/           # 主题
    │   └── app_theme.dart
    └── extension/       # 扩展方法
        └── string_extension.dart
```

## Import路径更新规则

### 旧路径 → 新路径

1. **Models**
   - `lib/data/models/*` → `lib/models/*`
   - `lib/core/models/*` → `lib/models/*`

2. **Views**
   - `lib/presentation/pages/*` → `lib/views/pages/*`
   - `lib/presentation/widgets/*` → `lib/views/widgets/*`

3. **ViewModels**
   - `lib/presentation/viewmodels/*` → `lib/viewmodels/*`

4. **Services**
   - `lib/core/network/*` → `lib/services/network/*`
   - `lib/data/datasources/local_storage.dart` → `lib/services/local_storage.dart`

5. **Repositories**
   - `lib/data/repositories/*` → `lib/repositories/*`
   - `lib/domain/repositories/*` → `lib/repositories/*`

6. **Utils**
   - `lib/core/utils/*` → `lib/utils/*`

7. **Core** (保持不变)
   - `lib/core/constants/*` → `lib/core/constants/*`
   - `lib/core/router/*` → `lib/core/router/*`
   - `lib/core/theme/*` → `lib/core/theme/*`
   - `lib/core/extension/*` → `lib/core/extension/*`

## 需要更新的Import示例

### 在ViewModels中
```dart
// 旧
import '../../domain/repositories/user_repository.dart';
import '../../data/models/user_model.dart';
import '../../core/utils/logger_util.dart';
import '../../core/utils/toast_util.dart';
import '../../data/datasources/local_storage.dart';
import '../providers/app_providers.dart';

// 新
import '../repositories/user_repository.dart';
import '../models/user_model.dart';
import '../utils/logger_util.dart';
import '../utils/toast_util.dart';
import '../services/local_storage.dart';
import 'app_providers.dart'; // 如果providers也移动到合适的位置
```

### 在Views中
```dart
// 旧
import '../../core/utils/logger_util.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';

// 新
import '../../utils/logger_util.dart';
import '../../viewmodels/auth_viewmodel.dart';
```

### 在Services中
```dart
// 旧
import '../api_define.dart';
import '../api_response.dart';
import '../api_exception.dart';
import 'interceptors/auth_interceptor.dart';

// 新
import 'api_define.dart';
import 'api_response.dart';
import 'api_exception.dart';
import 'interceptors/auth_interceptor.dart';
```

## 迁移步骤

1. ✅ 创建新文件夹结构
2. ✅ 移动models文件
3. ⏳ 移动views文件（pages和widgets）
4. ⏳ 移动viewmodels文件
5. ⏳ 移动services文件（网络、存储等）
6. ⏳ 移动repositories文件
7. ⏳ 移动utils文件
8. ⏳ 更新所有import路径
9. ⏳ 更新main.dart和app_providers.dart
10. ⏳ 删除旧文件夹
11. ⏳ 更新README文档

