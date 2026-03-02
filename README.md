# Smart Traffic Light

IEC 61131-3 Structured Text traffic light controller — a demo project for [STruC++](https://github.com/Autonomy-Logic/STruCpp).

## Overview

This project implements a smart traffic light intersection controller using IEC 61131-3 Structured Text. It demonstrates how to structure, compile, and test an ST project using the STruC++ compiler in a CI pipeline.

## Getting Started

Install STruC++:

```bash
# Via npm
npm install -g strucpp

# Or download from releases
# https://github.com/Autonomy-Logic/STruCpp/releases
```

Compile the project:

```bash
strucpp src/DataTypes/*.st src/Functions/*.st src/FunctionBlocks/*.st src/Programs/*.st -o build/intersection.cpp
```

Run tests:

```bash
strucpp src/DataTypes/*.st src/Functions/*.st src/FunctionBlocks/*.st --test tests/test_*.st
```

## Project Structure

```
src/
├── DataTypes/        # ENUM and STRUCT type definitions
├── Functions/        # Standalone functions (timing utilities)
├── FunctionBlocks/   # Function blocks (TrafficLight, PedestrianLight, ...)
└── Programs/         # Main programs (IntersectionController)
tests/                # Test files using STruC++ test framework
```

## License

MIT
