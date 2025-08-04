# Beyond Flutter CLI for Supabase

A powerful CLI tool for bootstrapping Flutter projects with a Supabase backend and a clean architecture.

## 🚀 Features

- **🏗️ Project Scaffolding**: Generates a complete, runnable Flutter project with a clean architecture.
- ** supabase_integration**: Seamlessly integrates with Supabase for authentication and data storage.
- **🧩 Feature Generation**: Quickly create new features with all the necessary layers (data, domain, presentation).
- **⚙️ Command-Runner Structure**: A robust and extensible CLI structure based on `package:args`.
- **🔧 Maintainable Code**: Uses Dart hooks for dependency injection, ensuring type safety and maintainability.

## 📦 Installation

1.  **Activate from Git:**

    ```bash
    dart pub global activate --source git https://github.com/beyondchasm/beyondFlutterCli.git
    ```

2.  **Ensure you have the following in your PATH:**
    - Flutter SDK
    - Dart SDK
    - The pub cache (`.pub-cache/bin`)

## 🛠 Usage

### Create a New Project

```bash
# Create a new directory for your project
mkdir my_awesome_app
cd my_awesome_app

# Generate the project scaffold
beyond scaffold --org com.example.myapp --with-auth --with-user
```

**Options:**

- `--org`: (Required) The organization name for your project (e.g., `com.example.myapp`).
- `--with-auth`: Include a pre-built authentication feature (login, signup).
- `--with-user`: Include a pre-built user profile feature.

### Generate a New Feature

```bash
# Inside your project directory
beyond feature products
```

This will create a new feature named `products` with the following structure:

```
lib/features/products/
├── data/
├── domain/
└── presentation/
```

### Initialize a Configuration File

```bash
beyond init
```

This creates a `beyond_cli.yaml` file to set default values for your project.

## 🏗 Architecture

This CLI tool enforces a clean architecture with three main layers:

- **Data**: Handles data retrieval and storage (e.g., from Supabase).
- **Domain**: Contains the core business logic and entities.
- **Presentation**: The UI layer of your application.

## 🤝 Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request.

## 📝 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
