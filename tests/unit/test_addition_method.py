from demo_app.addition_method import addition_method


def test_addition_method_given_two_integers():
    # Given
    a, b = 1, 2
    expected_result = 3

    # When
    result = addition_method(a=a, b=b)

    # Then
    assert result == expected_result


def test_addition_method_given_single_integer():
    # Given
    a = 1
    expected_result = 1

    # When
    result = addition_method(a=a)

    # Then
    assert result == expected_result
