"""Tests for business step instrumentation - milestone log patterns."""
import pytest
import os
import re


AGENT_DIR = os.path.join(os.path.dirname(__file__), '..')


def test_milestone_log_pattern_m1_achieved():
    """M1 achievement log must be present in billing review skill."""
    skill_path = os.path.join(AGENT_DIR, 'app', 'skills', 'billing-review', 'SKILL.md')
    with open(skill_path, 'r') as f:
        content = f.read()
    assert 'M1.achieved' in content


def test_milestone_log_pattern_m1_missed():
    """M1 miss log must be present in billing review skill."""
    skill_path = os.path.join(AGENT_DIR, 'app', 'skills', 'billing-review', 'SKILL.md')
    with open(skill_path, 'r') as f:
        content = f.read()
    assert 'M1.missed' in content


def test_milestone_log_pattern_m2_achieved():
    """M2 achievement log must be present in billing review skill."""
    skill_path = os.path.join(AGENT_DIR, 'app', 'skills', 'billing-review', 'SKILL.md')
    with open(skill_path, 'r') as f:
        content = f.read()
    assert 'M2.achieved' in content


def test_milestone_log_pattern_m4_achieved():
    """M4 achievement log (summary generated) must be present in billing review skill."""
    skill_path = os.path.join(AGENT_DIR, 'app', 'skills', 'billing-review', 'SKILL.md')
    with open(skill_path, 'r') as f:
        content = f.read()
    assert 'M4.achieved' in content


def test_milestone_log_pattern_m5_achieved():
    """M5 achievement log (out-of-scope) must be present in out-of-scope skill."""
    skill_path = os.path.join(AGENT_DIR, 'app', 'skills', 'out-of-scope', 'SKILL.md')
    with open(skill_path, 'r') as f:
        content = f.read()
    assert 'M5.achieved' in content


def test_milestone_ids_cover_all_five():
    """All five milestones (M1-M5) must be documented across the skills."""
    billing_path = os.path.join(AGENT_DIR, 'app', 'skills', 'billing-review', 'SKILL.md')
    oos_path = os.path.join(AGENT_DIR, 'app', 'skills', 'out-of-scope', 'SKILL.md')
    
    with open(billing_path, 'r') as f:
        billing_content = f.read()
    with open(oos_path, 'r') as f:
        oos_content = f.read()
    
    combined = billing_content + oos_content
    for i in range(1, 6):
        assert f'M{i}.' in combined, f"Milestone M{i} not found in skills"
