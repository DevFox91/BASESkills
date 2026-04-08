#!/usr/bin/env python3
"""Chequeo ligero de integridad del paquete BASE Skills."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def fail(message: str, failures: list[str]) -> None:
    failures.append(message)


def check_manifest(repo_root: Path, failures: list[str]) -> tuple[dict, list[dict]]:
    manifest_path = repo_root / "manifest.json"
    if not manifest_path.is_file():
        fail(f"Falta {manifest_path}", failures)
        return {}, []

    try:
        manifest = json.loads(read_text(manifest_path))
    except json.JSONDecodeError as exc:
        fail(f"manifest.json invalido: {exc}", failures)
        return {}, []

    skills = manifest.get("skills")
    if not isinstance(skills, list) or not skills:
        fail("manifest.json no contiene una lista valida en 'skills'", failures)
        return manifest, []

    return manifest, skills


def check_skill_catalog(repo_root: Path, manifest_skills: list[dict], failures: list[str]) -> tuple[list[str], list[str]]:
    skills_root = repo_root / "skills"
    if not skills_root.is_dir():
        fail(f"Falta el directorio {skills_root}", failures)
        return [], []

    manifest_folders: list[str] = []
    manifest_names: list[str] = []
    for skill in manifest_skills:
        name = skill.get("name")
        folder = skill.get("folder")
        if not isinstance(name, str) or not isinstance(folder, str):
            fail(f"Entrada de skill invalida en manifest.json: {skill}", failures)
            continue
        manifest_names.append(name)
        manifest_folders.append(folder)

    if len(set(manifest_names)) != len(manifest_names):
        fail("manifest.json contiene nombres de skill duplicados", failures)
    if len(set(manifest_folders)) != len(manifest_folders):
        fail("manifest.json contiene carpetas de skill duplicadas", failures)

    disk_folders = sorted(path.name for path in skills_root.iterdir() if path.is_dir())

    missing_on_disk = sorted(set(manifest_folders) - set(disk_folders))
    extra_on_disk = sorted(set(disk_folders) - set(manifest_folders))

    for folder in missing_on_disk:
        fail(f"La skill declarada '{folder}' no existe en skills/", failures)
    for folder in extra_on_disk:
        fail(f"La carpeta skills/{folder} no aparece en manifest.json", failures)

    for folder in manifest_folders:
        skill_dir = skills_root / folder
        if not skill_dir.is_dir():
            continue
        skill_md = skill_dir / "SKILL.md"
        if not skill_md.is_file():
            fail(f"Falta {skill_md}", failures)
        openai_yaml = skill_dir / "agents" / "openai.yaml"
        if not openai_yaml.is_file():
            fail(f"Falta {openai_yaml}", failures)

    return manifest_names, manifest_folders


def check_readme(repo_root: Path, manifest_names: list[str], manifest_count: int, failures: list[str]) -> None:
    readme_path = repo_root / "README.md"
    if not readme_path.is_file():
        fail(f"Falta {readme_path}", failures)
        return

    readme = read_text(readme_path)

    count_match = re.search(r"Numero de skills incluidas:\s*`(\d+)`", readme)
    if not count_match:
        fail("README.md no declara 'Numero de skills incluidas'", failures)
    elif int(count_match.group(1)) != manifest_count:
        fail(
            "README.md indica un numero de skills distinto al manifest.json "
            f"({count_match.group(1)} != {manifest_count})",
            failures,
        )

    skills_section_match = re.search(
        r"## Skills incluidas\n(.*?)(?:\n## |\Z)",
        readme,
        flags=re.DOTALL,
    )
    if not skills_section_match:
        fail("README.md no contiene la seccion '## Skills incluidas'", failures)
        return

    skills_section = skills_section_match.group(1)
    readme_skills = set(re.findall(r"^- `([^`]+)`: ", skills_section, flags=re.MULTILINE))
    missing_in_readme = sorted(set(manifest_names) - readme_skills)
    extra_in_readme = sorted(readme_skills - set(manifest_names))

    for name in missing_in_readme:
        fail(f"README.md no lista la skill '{name}'", failures)
    for name in extra_in_readme:
        fail(f"README.md lista la skill '{name}' que no existe en manifest.json", failures)


def check_agent_install(repo_root: Path, manifest_names: list[str], failures: list[str]) -> None:
    install_doc = repo_root / "AGENT_INSTALL.md"
    if not install_doc.is_file():
        fail(f"Falta {install_doc}", failures)
        return

    content = read_text(install_doc)
    table_skills = set(re.findall(r"^\|\s*`([^`]+)`\s*\|", content, flags=re.MULTILINE))
    missing_in_doc = sorted(set(manifest_names) - table_skills)
    extra_in_doc = sorted(table_skills - set(manifest_names))

    for name in missing_in_doc:
        fail(f"AGENT_INSTALL.md no lista la skill '{name}' en la tabla final", failures)
    for name in extra_in_doc:
        fail(f"AGENT_INSTALL.md lista la skill '{name}' que no existe en manifest.json", failures)


def main() -> int:
    repo_root = Path(__file__).resolve().parent.parent
    failures: list[str] = []

    manifest, manifest_skills = check_manifest(repo_root, failures)
    manifest_names, _ = check_skill_catalog(repo_root, manifest_skills, failures)
    check_readme(repo_root, manifest_names, len(manifest_skills), failures)
    check_agent_install(repo_root, manifest_names, failures)

    if failures:
        print("ERROR: el paquete BASE Skills tiene incoherencias internas.")
        for issue in failures:
            print(f"- {issue}")
        return 1

    version = manifest.get("version", "No verificable")
    print(
        "OK: integridad verificada para BASE Skills "
        f"(version {version}, {len(manifest_skills)} skills)."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
