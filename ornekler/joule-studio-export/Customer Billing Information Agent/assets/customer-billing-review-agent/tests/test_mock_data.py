"""Tests for the mcp-mock.json structure and mock data scenarios."""
import pytest
import json
import os


@pytest.fixture
def mock_config():
    """Load mcp-mock.json from agent root."""
    mock_path = os.path.join(os.path.dirname(__file__), '..', 'mcp-mock.json')
    with open(mock_path, 'r') as f:
        return json.load(f)


def test_mock_config_is_valid_json(mock_config):
    """mcp-mock.json must be parseable valid JSON."""
    assert mock_config is not None


def test_mock_config_has_servers(mock_config):
    """mcp-mock.json must have a servers section."""
    assert "servers" in mock_config
    assert len(mock_config["servers"]) >= 2


def test_mock_config_has_billing_server(mock_config):
    """mcp-mock.json must include a billing document server."""
    servers = mock_config["servers"]
    billing_servers = [k for k in servers if "billing" in k.lower() or "sap_self" in servers[k].get("mcp_server_name", "")]
    assert len(billing_servers) >= 1, "Expected at least one billing server"


def test_mock_config_has_contract_server(mock_config):
    """mcp-mock.json must include a contract payment server."""
    servers = mock_config["servers"]
    contract_servers = [k for k in servers if "contract" in k.lower() or "payment" in k.lower() or "cabuspartpayment" in servers[k].get("mcp_server_name", "").lower()]
    assert len(contract_servers) >= 1, "Expected at least one contract server"


def test_billing_server_has_list_tool(mock_config):
    """Billing server must expose a list billing documents tool."""
    servers = mock_config["servers"]
    for server_key, server in servers.items():
        tools = server.get("tools", {})
        list_tools = [t for t in tools if "list" in t.lower() and "billing" in t.lower()]
        if list_tools:
            return
    pytest.fail("No list billing documents tool found in any server")


def test_billing_server_mock_has_two_customer_scenarios(mock_config):
    """Billing server mock data must include at least two different customers."""
    servers = mock_config["servers"]
    for server_key, server in servers.items():
        tools = server.get("tools", {})
        for tool_name, tool in tools.items():
            if "list" in tool_name.lower() and "billing" in tool_name.lower():
                results = tool.get("mock_response", {}).get("results", [])
                customers = set(r.get("SoldToParty") for r in results if r.get("SoldToParty"))
                assert len(customers) >= 2, f"Expected at least 2 customer scenarios in {tool_name}"
                return
    pytest.fail("No list billing documents tool found to check customer scenarios")


def test_mock_has_noncompliant_customer_scenario(mock_config):
    """Mock data must include metadata describing a non-compliant customer scenario."""
    metadata = mock_config.get("metadata", {})
    scenarios = metadata.get("mock_scenarios", {})
    # At least one scenario should mention overdue/non-compliant
    noncompliant = [k for k, v in scenarios.items() if "NON-COMPLIANT" in v or "overdue" in v.lower()]
    assert len(noncompliant) >= 1, "Expected at least one non-compliant customer scenario in metadata"


def test_mock_has_compliant_customer_scenario(mock_config):
    """Mock data must include metadata describing a compliant customer scenario."""
    metadata = mock_config.get("metadata", {})
    scenarios = metadata.get("mock_scenarios", {})
    compliant = [k for k, v in scenarios.items() if "COMPLIANT" in v and "NON-COMPLIANT" not in v]
    assert len(compliant) >= 1, "Expected at least one compliant customer scenario in metadata"


def test_mock_metadata_is_present(mock_config):
    """mcp-mock.json must have a metadata section."""
    assert "metadata" in mock_config
    assert mock_config["metadata"].get("mock_mode") is True
    assert mock_config["metadata"].get("deterministic") is True
    assert mock_config["metadata"].get("created_for_agent") == "customer-billing-review-agent"


def test_all_tools_have_mock_response(mock_config):
    """Every tool in mcp-mock.json must have a mock_response."""
    servers = mock_config["servers"]
    for server_key, server in servers.items():
        tools = server.get("tools", {})
        for tool_name, tool in tools.items():
            assert "mock_response" in tool, f"Tool {tool_name} in server {server_key} missing mock_response"
            assert tool["mock_response"] is not None


def test_all_tools_have_input_schema(mock_config):
    """Every tool in mcp-mock.json must have an input_schema."""
    servers = mock_config["servers"]
    for server_key, server in servers.items():
        tools = server.get("tools", {})
        for tool_name, tool in tools.items():
            assert "input_schema" in tool, f"Tool {tool_name} in server {server_key} missing input_schema"
