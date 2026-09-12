# NIfTI Conversion Wrapper

A small Bash wrapper for converting source imaging data to NIfTI with `dcm2niix`.

## Workflow

```text
Source data
    ↓
Input validation
    ↓
Subject/session assignment
    ↓
dcm2niix conversion
    ↓
Organized output
    ↓
Downstream QC or BIDS preparation
```

Additional workflow documentation is available in [`docs/workflow.md`](docs/workflow.md).

## Repository layout

```text
NIfTI_conversion_wrapper/
├── bin/
│   └── nifti-convert
├── scripts/
│   ├── helpers.sh
│   ├── validate_input.sh
│   └── convert_subject.sh
├── config/
│   └── example.env
├── docs/
│   └── workflow.md
├── .gitignore
├── LICENSE
└── README.md
```

## Requirements

* Bash 4+
* `dcm2niix`
* Standard Unix utilities
* `realpath` or Python 3

Confirm that `dcm2niix` is available:

```bash
dcm2niix -h
```

## Installation

```bash
git clone <repository-url> NIfTI_conversion_wrapper
cd NIfTI_conversion_wrapper
chmod +x bin/nifti-convert scripts/*.sh
```

Optional local configuration:

```bash
cp config/example.env config/local.env
```

`config/local.env` is excluded from Git and should be used for machine-specific paths and settings.

## Usage

```bash
./bin/nifti-convert \
  --input /path/to/source/sub-001 \
  --output /path/to/converted \
  --subject sub-001
```

With a session:

```bash
./bin/nifti-convert \
  --input /path/to/source/sub-001/session1 \
  --output /path/to/converted \
  --subject sub-001 \
  --session ses-01
```

Example output:

```text
/path/to/converted/
└── sub-001/
    └── ses-01/
        └── <converted files>
```

## Dry run

Inspect the conversion command without launching the converter:

```bash
./bin/nifti-convert \
  --input /path/to/source/sub-001 \
  --output /path/to/converted \
  --subject sub-001 \
  --dry-run
```

## Safety

The wrapper:

* validates source directories and subject/session identifiers;
* refuses to write into an existing target unless `--force` is supplied;
* quotes filesystem paths;
* excludes local configuration from Git;
* returns non-zero exit codes on failure;
* supports a no-write dry-run mode.

Review all paths and proposed outputs before processing research data.

## Configuration

Default settings are documented in [`config/example.env`](config/example.env):

```bash
CONVERTER_BIN=dcm2niix
DICOM_FILENAME_PATTERN=%p_%s
DICOM_GZIP=y
DICOM_OVERWRITE=n
```

Do not commit `config/local.env`, source imaging data, converted outputs, logs, credentials or machine-specific paths.

## Help

```bash
./bin/nifti-convert --help
```

## License

MIT.
