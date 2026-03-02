# App Architecture (Mason Brick)

A highly scalable, clean architecture Flutter starter template. Includes pre-configured CI/CD pipelines, comprehensive documentation templates, AI agent roles, and environment handling.

## Usage (Anywhere, Any Computer)

You do not need to clone the original project to generate a new app! As long as you have the `mason_cli` installed, you can generate this structure.

### 1. Install Mason (One-time setup)
```bash
dart pub global activate mason_cli
```

### 2. Add the Brick
Add this brick globally to your machine from your Git repository (Note: you must push this `app_brick` folder to a repo first, or just keep it locally).

**From Local Path:**
```bash
mason add app_architecture --path /path/to/app_brick
```

**From GitHub (Recommended for remote computers):**
```bash
mason add app_architecture --git https://github.com/your-username/your-repo.git --path app_brick
```

### 3. Generate Your New Project
Go to the folder where you want your new app to live, create a standard Flutter project, and then inject the architecture:

```bash
flutter create --org com.myorg my_awesome_app
cd my_awesome_app
mason make app_architecture
```

Mason will ask you for your project name and org name, and instantly inject all the core files, docs, and rules, automatically renaming all the imports to match your new project!
