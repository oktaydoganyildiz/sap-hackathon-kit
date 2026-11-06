"""Tests for runtime skills structure and content."""
import pytest
import os
import yaml


SKILLS_DIR = os.path.join(os.path.dirname(__file__), '..', 'app', 'skills')


def load_skill_frontmatter(skill_name):
    """Load and parse a skill's YAML frontmatter."""
    skill_path = os.path.join(SKILLS_DIR, skill_name, 'SKILL.md')
    with open(skill_path, 'r') as f:
        content = f.read()
    # Extract YAML frontmatter between --- markers
    if content.startswith('---'):
        end = content.find('---', 3)
        if end != -1:
            return yaml.safe_load(content[3:end])
    return {}


def test_billing_review_skill_exists():
    """billing-review skill directory and SKILL.md must exist."""
    skill_path = os.path.join(SKILLS_DIR, 'billing-review', 'SKILL.md')
    assert os.path.exists(skill_path), "billing-review/SKILL.md does not exist"


def test_out_of_scope_skill_exists():
    """out-of-scope skill directory and SKILL.md must exist."""
    skill_path = os.path.join(SKILLS_DIR, 'out-of-scope', 'SKILL.md')
    assert os.path.exists(skill_path), "out-of-scope/SKILL.md does not exist"


def test_billing_review_skill_has_frontmatter():
    """billing-review SKILL.md must have valid YAML frontmatter with name and description."""
    fm = load_skill_frontmatter('billing-review')
    assert fm.get('name') == 'billing-review', "Skill name must be 'billing-review'"
    assert 'description' in fm and len(fm['description']) > 0


def test_out_of_scope_skill_has_frontmatter():
    """out-of-scope SKILL.md must have valid YAML frontmatter with name and description."""
    fm = load_skill_frontmatter('out-of-scope')
    assert fm.get('name') == 'out-of-scope', "Skill name must be 'out-of-scope'"
    assert 'description' in fm and len(fm['description']) > 0


def test_billing_review_skill_mentions_summary_format():
    """billing-review SKILL.md must include the Customer Billing Review Summary format."""
    skill_path = os.path.join(SKILLS_DIR, 'billing-review', 'SKILL.md')
    with open(skill_path, 'r') as f:
        content = f.read()
    assert "Customer Billing Review Summary" in content


def test_billing_review_skill_mentions_milestone_logs():
    """billing-review SKILL.md must mention milestone log statements."""
    skill_path = os.path.join(SKILLS_DIR, 'billing-review', 'SKILL.md')
    with open(skill_path, 'r') as f:
        content = f.read()
    assert "M1.achieved" in content or "M2.achieved" in content


def test_out_of_scope_skill_lists_prohibited_actions():
    """out-of-scope SKILL.md must list all prohibited action categories."""
    skill_path = os.path.join(SKILLS_DIR, 'out-of-scope', 'SKILL.md')
    with open(skill_path, 'r') as f:
        content = f.read()
    prohibited = ["credit", "write-off", "collection", "invoice", "payment terms"]
    for term in prohibited:
        assert term.lower() in content.lower(), f"Expected '{term}' in out-of-scope skill"


def test_out_of_scope_skill_has_decline_template():
    """out-of-scope SKILL.md must include a decline message template."""
    skill_path = os.path.join(SKILLS_DIR, 'out-of-scope', 'SKILL.md')
    with open(skill_path, 'r') as f:
        content = f.read()
    assert "read-only" in content.lower() or "mandate" in content.lower()
