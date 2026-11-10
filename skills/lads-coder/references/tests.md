# Good and bad tests

Examples are in Python with pytest; the principles apply to any language. Each pair shows the same intent written badly, then well.

## Test behaviour, not implementation

```python
# Bad: asserts how the total is computed. Renaming or inlining
# _apply_discount breaks the test, although the behaviour is unchanged.
def test_checkout_calls_apply_discount(mocker):
    spy = mocker.spy(pricing, "_apply_discount")
    checkout(cart_with(items=3), code="SPRING10")
    spy.assert_called_once()

# Good: asserts what the caller gets.
def test_discount_code_reduces_total():
    receipt = checkout(cart_with(price=100), code="SPRING10")
    assert receipt.total == 90
```

## Read state back through the interface

```python
# Bad: reaches past the interface into storage, so the test depends on
# table and column names the caller never sees.
def test_register_user_inserts_row(db):
    register_user(email="ada@example.com")
    assert db.execute("SELECT 1 FROM users WHERE email = ?", ["ada@example.com"]).fetchone()

# Good: proves the observable effect: the user can be found afterwards.
def test_registered_user_can_be_found():
    user = register_user(email="ada@example.com")
    assert find_user(user.id).email == "ada@example.com"
```

## Expected values are independent literals

```python
# Bad: recomputes the expectation the same way the code does.
# If the formula is wrong, code and test are wrong together and it still passes.
def test_invoice_total():
    lines = [Line(price=20, qty=3), Line(price=5, qty=2)]
    assert invoice_total(lines) == sum(l.price * l.qty for l in lines)

# Good: the value was worked out by hand: 20*3 + 5*2 = 70.
def test_invoice_total_sums_all_lines():
    assert invoice_total([Line(price=20, qty=3), Line(price=5, qty=2)]) == 70
```

## One behaviour per test, named after it

```python
# Bad: several behaviours, a vague name, and logic inside the test.
def test_token():
    for age in [0, 59, 61]:
        if age < 60:
            assert is_valid(token_issued(minutes_ago=age))
        else:
            assert not is_valid(token_issued(minutes_ago=age))

# Good: each test documents one rule.
def test_token_is_valid_within_an_hour():
    assert is_valid(token_issued(minutes_ago=59))

def test_token_expires_after_an_hour():
    assert not is_valid(token_issued(minutes_ago=61))
```

## Mock only what you don't own

```python
# Bad: mocks the project's own module, so the test only proves
# that the code calls the mock.
def test_order_confirmation(mocker):
    mocker.patch("shop.orders.build_email", return_value="ok")
    assert confirm_order(order) == "ok"

# Good: fakes the external email provider (a boundary) and checks
# what actually leaves the system.
def test_confirmed_order_emails_the_customer(fake_mailer):
    confirm_order(order_for("ada@example.com"), mailer=fake_mailer)
    assert fake_mailer.sent_to == ["ada@example.com"]
```
