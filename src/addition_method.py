DEAD_CONSTANT = 'Nobody use me'


def addition_method(a: int, b: int = None) -> str:
    if b is not None:
        return a + b
    else:
        return a
