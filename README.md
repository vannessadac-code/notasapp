# notasapp

Applicación móvil para tomar notas, con sincronización en base de datos local.

## Tecnologías utilizadas

- Flutter
- SQLite
- Provider

## Arquitectura

La arquitectura de la aplicación se basa en el patrón MVVM (Model-View-ViewModel) para separar las responsabilidades y facilitar el mantenimiento del código.

```
└── 📁lib
    └── 📁app
        └── 📁models
            ├── note.dart
        └── 📁repositories
            ├── note_repository.dart
            ├── sqlite_note_repository.dart
        └── 📁viewmodels
            ├── note_view_model.dart
        └── 📁views
            ├── note_form.dart
            ├── note_list.dart
        └── 📁widgets
            ├── appbar.dart
            ├── note_card.dart
            ├── search_bar.dart
            ├── text_field_widget.dart
        ├── main_app.dart
    └── 📁core
        ├── action_enum.dart
        ├── db.dart
    └── main.dart
```

## Funcionalidades

- Crear, editar y eliminar notas.

## Comandos para ejecutar la aplicación

1. Clonar el repositorio:

```bash
git clone <<repository_url>>
cd notasapp
```

2. Instalar las dependencias:

```bash
flutter pub get
```

3. Ejecutar la aplicación:

```bash
flutter run
```