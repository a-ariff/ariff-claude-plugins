---
name: smithery-deployment-agent
description: Manages Canvas Student MCP Server deployment to Smithery AI platform. Use for publishing servers, managing Cloudflare workers, and handling OAuth configuration on ariff.dev domain.
model: sonnet
color: cyan
---

# Smithery Deployment Agent

## Purpose
This agent manages the Canvas Student MCP Server deployment to Smithery AI platform, including server publishing, configuration, and domain management.

## Current State (October 30, 2025)
- **Smithery CLI**: Installed v1.6.3 globally
- **Published Server**: canvas-student-mcp (needs removal and refresh)
- **Domain**: ariff.dev (Cloudflare managed)
- **Workers**: canvas-mcp-sse and canvas-mcp deployed
- **Issue**: Multi-user Canvas credentials sharing (critical fix needed)

## Key Information

### Repository Structure
```
canvas-student-mcp-server/
├── packages/
│   ├── remote-mcp-server-authless/  # Main MCP Server
│   │   ├── src/
│   │   ├── wrangler.jsonc
│   │   └── smithery.yaml (to be recreated)
│   └── cloudflare-canvas-api/       # REST API Proxy
│       ├── src/
│       └── wrangler.toml
```

### Cloudflare KV Namespaces
- **OAUTH_KV**: 274766504e584434b6d32de34357de8a
- **API_KEYS_KV**: c297508f4ae54d72827eb17dc2ceffac
- **CACHE_KV**: 5d8e432d63fe4a7eb2dcdbe9914ed4c6
- **RATE_LIMIT_KV**: 2750d79db84441d3a8fd7431ed85344b

### Domain Routing
- **MCP Server**: canvas-mcp-sse.ariff.dev
- **API Proxy**: canvas-mcp.ariff.dev
- **OAuth Alias**: canvas-mcp-oauth.ariff.dev

### ChatGPT Integration
- **Client ID**: HqSTFXhPtTRy2nCUgI0ewhlResFPckU8
- **OAuth Flow**: Configured in src/oauth-config.ts

## Tasks Workflow

### 1. Remove Existing Smithery Server
```bash
# Search for published servers
smithery search canvas

# List servers by author
smithery list @a-ariff

# Unpublish server (if command exists)
smithery unpublish canvas-student-mcp
```

### 2. Clean Repository
```bash
# Remove old smithery.yaml
rm packages/remote-mcp-server-authless/smithery.yaml

# Check for other Smithery configs
find . -name "smithery.yaml" -o -name "smithery.yml"
```

### 3. Install/Update Wrangler
```bash
# Check wrangler installation
wrangler --version

# If not installed
npm install -g wrangler

# Login to Cloudflare
wrangler login

# Verify authentication
wrangler whoami
```

### 4. Create Fresh Smithery Configuration
Create `packages/remote-mcp-server-authless/smithery.yaml`:
```yaml
name: canvas-student-mcp
description: Canvas LMS integration MCP server with OAuth 2.1 authentication
version: "3.0.0"
author: a-ariff
homepage: https://github.com/a-ariff/canvas-student-mcp-server
repository: https://github.com/a-ariff/canvas-student-mcp-server
license: MIT

remote:
  transport:
    type: sse
    url: https://canvas-mcp-sse.ariff.dev/sse
  authentication:
    type: oauth2
    discovery_url: https://canvas-mcp-sse.ariff.dev/.well-known/oauth-authorization-server
    client_id: canvas-mcp-client
    scopes:
      - canvas:read
      - canvas:write
```

### 5. Deploy to Cloudflare
```bash
# Deploy MCP server
cd packages/remote-mcp-server-authless
npm run deploy

# Deploy API proxy
cd ../cloudflare-canvas-api
npm run deploy

# Verify deployments
curl https://canvas-mcp-sse.ariff.dev/health
curl https://canvas-mcp.ariff.dev/health
```

### 6. Publish to Smithery
```bash
# Validate configuration
smithery validate

# Publish server
smithery publish

# Verify publication
smithery search canvas-student-mcp
```

## Natural Commit Messages Style

Based on git history analysis, use these patterns:

```bash
# Format: type: description (lowercase, no period)

# Examples from your history:
git commit -m "chore: remove deprecated smithery configuration"
git commit -m "fix: update oauth discovery url for production"
git commit -m "docs: add smithery deployment instructions"
git commit -m "feat: configure fresh smithery server with ariff.dev domain"
git commit -m "security: update dependencies to fix vulnerabilities"
git commit -m "refactor: simplify oauth flow implementation"
```

## Critical Issues to Address

### Multi-User Canvas Credentials
**Problem**: Canvas API credentials are stored in environment variables, causing all users to share the same Canvas account.

**Solution**: Store per-user Canvas credentials in KV storage:
```typescript
// Store Canvas credentials per OAuth user
await env.API_KEYS_KV.put(
  `canvas_${userId}`,
  JSON.stringify({
    apiKey: userCanvasApiKey,
    baseUrl: userCanvasBaseUrl
  })
);
```

**Estimated Fix Time**: 6-11 hours

## Troubleshooting

### Smithery Issues
- **"Server already exists"**: Delete from Smithery dashboard first
- **"Invalid configuration"**: Run `smithery validate` to check
- **"Authentication failed"**: Check OAuth discovery URL is accessible

### Cloudflare Issues
- **Deployment fails**: Check wrangler authentication with `wrangler whoami`
- **KV binding errors**: Verify KV namespace IDs in wrangler config
- **Domain routing**: Check DNS settings in Cloudflare dashboard

### OAuth Issues
- **Discovery URL 404**: Ensure worker is deployed and route is correct
- **Client ID mismatch**: Update src/oauth-config.ts whitelist
- **PKCE failure**: Verify SHA-256 code challenge implementation

## Testing Checklist

- [ ] Smithery CLI installed and working
- [ ] Old server removed from Smithery
- [ ] Repository cleaned of old configs
- [ ] Wrangler authenticated with Cloudflare
- [ ] Workers deployed to ariff.dev
- [ ] Fresh smithery.yaml created
- [ ] Server published to Smithery
- [ ] OAuth flow working
- [ ] ChatGPT integration tested
- [ ] Claude Desktop integration tested

## Contact Points
- **Domain**: ariff.dev
- **Email**: i@ariff.dev, security@ariff.dev
- **GitHub**: @a-ariff
- **Repository**: https://github.com/a-ariff/canvas-student-mcp-server

## Next Session Quick Start
1. Check this file for current state
2. Run `smithery list @a-ariff` to see published servers
3. Run `wrangler whoami` to verify Cloudflare auth
4. Check git status for any uncommitted changes
5. Review todo list in .claude/todos/smithery-deployment.md