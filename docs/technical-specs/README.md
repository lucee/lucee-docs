# Technical Specifications

## Purpose

This directory contains technical specification documents optimized for rapid consumption by developers and AI systems already familiar with the underlying technologies.

## Content Format

- **Pure technical facts** - No explanatory content or tutorials
- **Structured data** - YAML, JSON, or minimal markdown for quick parsing
- **Implementation details** - Class names, configuration parameters, system properties
- **Integration points** - Required dependencies, API signatures, service registrations
- **Reference data** - Constants, aliases, supported formats, MIME types

## Target Audience

- Experienced developers implementing integrations
- AI systems generating code or configurations
- Technical teams needing quick reference data
- Tools requiring structured technical metadata

## What This Is NOT

- Step-by-step tutorials (see `/recipes/`)
- Conceptual explanations 
- Getting started guides
- Troubleshooting documentation

## Usage

These specifications assume familiarity with the base technology (e.g., JSR-223, JDBC, OSGi) and focus exclusively on Lucee-specific implementation details, configuration requirements, and integration parameters.

Example: JSR-223 spec contains engine names, required JARs, system properties, and usage patterns - not explanations of what JSR-223 is or why to use it.