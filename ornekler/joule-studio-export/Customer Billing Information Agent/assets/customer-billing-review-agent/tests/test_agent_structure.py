"""Tests for agent project structure and asset files."""
import pytest
import os
import yaml
import json


AGENT_DIR = os.path.join(os.path.dirname(__file__), '..')
SOLUTION_ROOT = os.path.join(AGENT_DIR, '..', '..')


def test_asset_yaml_exists():
    """asset.yaml must exist in the agent directory."""
    assert os.path.exists(os.path.join(AGENT_DIR, 'asset.yaml'))


def test_solution_yaml_exists():
    """solution.yaml must exist in the solution root."""
    assert os.path.exists(os.path.join(SOLUTION_ROOT, 'solution.yaml'))


def test_asset_yaml_is_valid():
    """asset.yaml must be valid YAML with required fields."""
    with open(os.path.join(AGENT_DIR, 'asset.yaml'), 'r') as f:
        asset = yaml.safe_load(f)
    assert asset['kind'] == 'Asset'
    assert asset['type'] == 'agent'
    assert asset['metadata']['name'] == 'customer-billing-review-agent'
    assert 'description' in asset['metadata']
    assert 'provides' in asset


def test_asset_yaml_has_a2a_api():
    """asset.yaml must declare an A2A API in provides.apis."""
    with open(os.path.join(AGENT_DIR, 'asset.yaml'), 'r') as f:
        asset = yaml.safe_load(f)
    apis = asset['provides']['apis']
    a2a_apis = [a for a in apis if a.get('kind') == 'a2a']
    assert len(a2a_apis) >= 1, "Agent must declare at least one A2A API"


def test_asset_yaml_requires_mcp_servers():
    """asset.yaml must require both MCP servers (billing and contract)."""
    with open(os.path.join(AGENT_DIR, 'asset.yaml'), 'r') as f:
        asset = yaml.safe_load(f)
    requires = asset.get('requires', [])
    mcp_reqs = [r for r in requires if r.get('kind') == 'mcp-server']
    assert len(mcp_reqs) >= 2, "Agent must require at least 2 MCP servers (billing and contract)"


def test_mcp_mock_json_exists():
    """mcp-mock.json must exist in the agent directory."""
    assert os.path.exists(os.path.join(AGENT_DIR, 'mcp-mock.json'))


def test_mcp_mock_json_is_valid():
    """mcp-mock.json must be valid JSON."""
    with open(os.path.join(AGENT_DIR, 'mcp-mock.json'), 'r') as f:
        mock = json.load(f)
    assert mock is not None


def test_billing_mcp_server_asset_exists():
    """Billing MCP server asset.yaml must exist."""
    billing_path = os.path.join(SOLUTION_ROOT, 'assets', 'sap-s4-ce-billingdocument-0001-mcp-server', 'asset.yaml')
    assert os.path.exists(billing_path), "Billing MCP server asset.yaml not found"


def test_contract_mcp_server_asset_exists():
    """Contract MCP server asset.yaml must exist."""
    contract_path = os.path.join(SOLUTION_ROOT, 'assets', 'sap-s4-api-cabuspartpayment-0002-mcp-server', 'asset.yaml')
    assert os.path.exists(contract_path), "Contract MCP server asset.yaml not found"


def test_solution_yaml_references_all_assets():
    """solution.yaml must reference all three assets (agent + 2 MCP servers)."""
    with open(os.path.join(SOLUTION_ROOT, 'solution.yaml'), 'r') as f:
        solution = yaml.safe_load(f)
    refs = [a['ref'] for a in solution.get('assets', [])]
    assert len(refs) >= 3, f"Expected 3+ asset references in solution.yaml, got {len(refs)}"
    assert any('customer-billing-review-agent' in r for r in refs)
    assert any('ce-billingdocument' in r or 'billing' in r for r in refs)
    assert any('cabuspartpayment' in r or 'contract' in r for r in refs)


def test_main_py_exists():
    """app/main.py must exist."""
    assert os.path.exists(os.path.join(AGENT_DIR, 'app', 'main.py'))


def test_agent_py_exists():
    """app/agent.py must exist."""
    assert os.path.exists(os.path.join(AGENT_DIR, 'app', 'agent.py'))
