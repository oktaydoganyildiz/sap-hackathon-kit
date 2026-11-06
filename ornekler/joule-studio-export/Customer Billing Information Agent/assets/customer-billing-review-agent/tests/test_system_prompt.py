"""Tests for the Customer Billing Review Agent system prompt and guardrails."""
import pytest
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'app'))
from agent import get_system_prompt


def test_system_prompt_is_nonempty():
    """The system prompt must be non-empty."""
    prompt = get_system_prompt()
    assert prompt and len(prompt) > 0


def test_system_prompt_identifies_agent():
    """System prompt must identify the agent as the Customer Billing Review Agent for Barton Industrial Supply."""
    prompt = get_system_prompt()
    assert "Customer Billing Review Agent" in prompt
    assert "Barton Industrial Supply" in prompt


def test_system_prompt_defines_billing_only_mode():
    """System prompt must define billing-only mode using only the billing tool."""
    prompt = get_system_prompt()
    assert "BILLING-ONLY" in prompt or "billing-only" in prompt.lower()


def test_system_prompt_defines_contract_only_mode():
    """System prompt must define contract-only mode using only the contract tool."""
    prompt = get_system_prompt()
    assert "CONTRACT-ONLY" in prompt or "contract-only" in prompt.lower()


def test_system_prompt_defines_full_review_mode():
    """System prompt must define full customer review mode using both tools."""
    prompt = get_system_prompt()
    assert "FULL CUSTOMER REVIEW" in prompt or "full customer review" in prompt.lower()


def test_system_prompt_prohibits_write_operations():
    """System prompt must explicitly prohibit all write/modify operations."""
    prompt = get_system_prompt()
    prohibited = ["NEVER", "Modify", "credits", "write-offs", "collection"]
    for term in prohibited:
        assert term.lower() in prompt.lower(), f"Expected '{term}' prohibition in system prompt"


def test_system_prompt_defines_review_summary_structure():
    """System prompt must define the Customer Billing Review Summary structure."""
    prompt = get_system_prompt()
    assert "Customer Billing Review Summary" in prompt or "Billing Overview" in prompt


def test_system_prompt_read_only_mandate():
    """System prompt must declare the agent as read-only."""
    prompt = get_system_prompt()
    assert "READ-ONLY" in prompt or "read-only" in prompt.lower()


def test_system_prompt_prohibits_invoice_modification():
    """System prompt must explicitly prohibit modifying invoices."""
    prompt = get_system_prompt()
    assert "invoice" in prompt.lower()
    assert "modify" in prompt.lower() or "NEVER" in prompt


def test_system_prompt_prohibits_collection_actions():
    """System prompt must explicitly prohibit initiating collection actions."""
    prompt = get_system_prompt()
    assert "collection" in prompt.lower()


def test_system_prompt_instructs_to_decline_out_of_scope():
    """System prompt must instruct the agent to decline out-of-scope requests."""
    prompt = get_system_prompt()
    assert "decline" in prompt.lower() or "politely" in prompt.lower()
