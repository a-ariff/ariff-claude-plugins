# Deep Search Command

Intelligent search across multiple sources using semantic vendor detection.

## Usage

```
/deep-search <query>
```

## How It Works

1. **Analyze Query** - Detect topics, technologies, vendors
2. **Route to Sources** - Select relevant sources based on topic
3. **Execute Search** - Query each source
4. **Synthesize** - Combine and summarize results

## Source Routing

### Always Searched
- **GitHub** - Code examples, implementations, issues

### Semantic Routing

| Topic Detected | Sources Added |
|---------------|---------------|
| Claude, Anthropic | docs.anthropic.com, Claude guides |
| Azure, Microsoft | Microsoft Learn, Azure docs |
| Intune, Endpoint | Microsoft Intune docs |
| Python | Python docs, PyPI |
| JavaScript, Node | MDN, npm |
| Canvas LMS | Canvas API docs |
| Terraform | Terraform Registry, HashiCorp docs |
| Kubernetes, K8s | kubernetes.io |
| Docker | Docker docs |
| AWS | AWS docs |
| Reddit discussion | reddit.com (via firecrawl) |

## Example Searches

```
/deep-search claude code hooks best practices
→ GitHub (claude-code), docs.anthropic.com

/deep-search intune windows 11 compliance policy
→ GitHub, Microsoft Learn, Intune docs

/deep-search python async best practices reddit
→ GitHub, Python docs, Reddit

/deep-search terraform azure container apps
→ GitHub, Terraform Registry, Azure docs
```

## Implementation

Uses **firecrawl-mcp** for web search and scraping:

```python
# Search with firecrawl
mcp__firecrawl-mcp__firecrawl_search(
    query="claude hooks best practices site:github.com OR site:docs.anthropic.com",
    limit=10
)

# For Reddit
mcp__firecrawl-mcp__firecrawl_search(
    query="site:reddit.com {query}",
    limit=5
)
```

## Manual Deep Search Steps

When using without command:

1. **GitHub Search:**
   ```
   Use github_repo or grep_search for code
   ```

2. **Web Search:**
   ```
   Use mcp__firecrawl-mcp__firecrawl_search with site: operators
   ```

3. **Fetch Full Content:**
   ```
   Use mcp__firecrawl-mcp__firecrawl_scrape for specific URLs
   ```

## Vendor Detection Keywords

```
CLAUDE_KEYWORDS = ["claude", "anthropic", "sonnet", "opus", "haiku", "mcp"]
AZURE_KEYWORDS = ["azure", "microsoft", "intune", "entra", "m365", "teams"]
AWS_KEYWORDS = ["aws", "amazon", "lambda", "s3", "ec2", "cloudformation"]
PYTHON_KEYWORDS = ["python", "pip", "django", "flask", "fastapi"]
JS_KEYWORDS = ["javascript", "typescript", "node", "react", "vue", "npm"]
K8S_KEYWORDS = ["kubernetes", "k8s", "helm", "kubectl", "pod", "deployment"]
DOCKER_KEYWORDS = ["docker", "container", "dockerfile", "compose"]
TERRAFORM_KEYWORDS = ["terraform", "hcl", "tfstate", "provider"]
```

## Notes

- **X.com/Twitter** - Not available (requires paid API)
- **Rate limits** - firecrawl has usage limits, batch wisely
- **Reddit** - Works via firecrawl web search
- **Results** - Always cite source URLs
