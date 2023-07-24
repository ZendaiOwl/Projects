* TOC
{:toc}

---
___Python___

_Random information about Python I've found and gathered_

### Virtual environment

Check if the virtual environment is active for the shell session.

`echo "$VIRTUAL_ENV"`

### Socket library

Test for dual-stack support: `socket.has_dualstack_ipv6()`

Example with `sanic` webserver

```python
@app.get('/test_dual-stack')
async def dual_stack_test(request):
    result = socket.has_dualstack_ipv6()
    return json({"dual-stack": result})
```

---
