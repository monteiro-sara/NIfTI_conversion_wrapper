# Workflow

This repository is organized around one public entry point: `bin/aumc-convert`.
The lower-level scripts are intentionally small so that AUMC-specific rules can
be added without turning the whole workflow into one large shell file.

```text
source imaging data
       │
       ▼
argument parsing
       │
       ▼
input + subject validation
       │
       ▼
resolve output directory
       │
       ▼
conversion backend
(default: dcm2niix)
       │
       ▼
subject[/session] output
       │
       ▼
summary / downstream QC
```

## Responsibilities

| Component | Responsibility |
|---|---|
| `bin/aumc-convert` | CLI, orchestration, subject/session naming |
| `scripts/validate_input.sh` | Fail early on unsafe or invalid inputs |
| `scripts/convert_subject.sh` | Converter command construction and execution |
| `scripts/helpers.sh` | Logging, config loading, path helpers |
| `config/local.env` | Machine-specific configuration; never committed |

## Where to add AUMC-specific logic

If the existing AUMC workflow contains sequence mapping, renaming, metadata
patching, or post-conversion organization, place each concern in its own script,
for example:

```text
scripts/
├── convert_subject.sh
├── map_sequences.sh
├── patch_metadata.sh
└── organize_output.sh
```

Then call those stages from `bin/aumc-convert` in order. This keeps the public
CLI stable even if the implementation changes.
