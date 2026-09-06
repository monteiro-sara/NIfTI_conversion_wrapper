## Workflow

```text
RAW / SOURCE DATA
       │
       ▼
  validate input
       │
       ▼
subject / session ID
       │
       ▼
  dcm2niix conversion
       │
       ▼
organized output folder
       │
       ▼
 downstream QC / BIDS step
```

Full workflow notes: [`docs/workflow.md`](docs/workflow.md)

## Repository layout

```text
converter_AUMC/
├── bin/
│   └── aumc-convert          # public command-line entry point
├── scripts/
│   ├── helpers.sh            # logging + utility functions
│   ├── validate_input.sh     # fail-fast input checks
│   └── convert_subject.sh    # conversion backend
├── config/
│   └── example.env           # copy to local.env for local settings
├── docs/
│   └── workflow.md
├── .gitignore
├── LICENSE
└── README.md
```

## Requirements

- Bash 4+
- `dcm2niix` available on `PATH` (default backend)
- standard Unix tools: `find`, `grep`, `wc`
- `realpath` or Python 3 for absolute-path resolution

Check `dcm2niix`:

```bash
dcm2niix -h
```

## Quick start

Clone and enter the repository:

```bash
git clone https://github.com/monteiro-sara/converter_AUMC.git
cd converter_AUMC
```

The entry point is already executable in the repository. If permissions are
lost during transfer:

```bash
chmod +x bin/aumc-convert scripts/*.sh
```

Optional machine-specific configuration:

```bash
cp config/example.env config/local.env
```

`config/local.env` is ignored by Git and is therefore the right place for local
paths or converter flags.

## Usage

```bash
./bin/aumc-convert \
  --input /path/to/source/sub-001 \
  --output /path/to/converted \
  --subject sub-001
```

With a session:

```bash
./bin/aumc-convert \
  --input /path/to/source/sub-001/session1 \
  --output /path/to/converted \
  --subject sub-001 \
  --session ses-01
```

The resulting structure is:

```text
/path/to/converted/
└── sub-001/
    └── ses-01/
        ├── <converted files>
        └── ...
```

## Dry run first

Before running a large conversion, inspect the exact command:

```bash
./bin/aumc-convert \
  --input /path/to/source/sub-001 \
  --output /path/to/converted \
  --subject sub-001 \
  --dry-run
```

No converter process is launched in dry-run mode.

## Safety behaviour

The wrapper uses:

```bash
set -Eeuo pipefail
```

and intentionally:

- validates that the source exists and contains files;
- validates subject/session identifiers;
- refuses to write into an existing target directory unless `--force` is used;
- quotes filesystem paths;
- keeps machine-specific configuration out of Git;
- returns non-zero exit codes on failure;
- supports a no-write `--dry-run` mode.

## Configuration

Default settings are documented in [`config/example.env`](config/example.env).

Typical local configuration:

```bash
CONVERTER_BIN=dcm2niix
DICOM_FILENAME_PATTERN=%p_%s
DICOM_GZIP=y
DICOM_OVERWRITE=n
```

Do **not** commit `config/local.env` if it contains local paths or sensitive
information.

The safest place to preserve existing project-specific logic is
`scripts/convert_subject.sh`, or a new dedicated stage such as:

```text
scripts/map_sequences.sh
scripts/patch_metadata.sh
scripts/organize_output.sh
```

The command-line interface can then remain stable while those internals evolve.

## Help

```bash
./bin/aumc-convert --help
```

## License

MIT.
