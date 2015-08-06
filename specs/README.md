# Specifications for OCaml modules

## Notes
- The synthesized features have input variables names as `x0g`, `x1g` and so on ...

## String

### Properties

#### String.get

```
precondition: (i < 0 || !(len(s) > i))
postcondition: exception thrown

precondition: !(i < 0) && len(s) > i
postcondition: terminates normally
```

#### String.index

```
precondition: !(for any se in s -> se = c)
postcondition: exception thrown
```

### Mutators

#### String.copy

```
precondition: false
postcondition: exception thrown

precondition: true
postcondition: terminates normally

precondition: !(len(s) = 0)
postcondition: len(res) > 0

precondition: len(s) = 0
postcondition: len(res) = 0

precondition: false
postcondition: s > res

precondition: true
postcondition: s = res

precondition: false
postcondition: len(s) > len(res)

precondition: true
postcondition: len(s) = len(res)
```

#### String.sub

```
precondition: (i1 < 0 || i2 < 0 || (x1g > ((len "x0g") - x2g)))
postcondition: exception thrown
```

#### String.make

```
precondition: (i < 0)
postcondition: exception thrown

precondition: !(i < 0)
postcondition: terminates normally

precondition: !(i = 0)
postcondition: len(res) > 0

precondition: i = 0
postcondition: len(res) = 0
```


## List

### Properties

#### List.length

```
precondition: false
postcondition: exception thrown

precondition: true
postcondition: terminates normally

precondition: !(len(l) = 0)
postcondition: res > 0

precondition: len(l) = 0
postcondition: res = 0

precondition: false
postcondition: len(l) > res

precondition: true
postcondition: len(l) = res
```

#### List.hd

```
precondition: len(l) = 0
postcondition: exception thrown

precondition: !(len(l) = 0)
postcondition: terminates normally
```

#### List.nth

```
precondition: (n < 0 || !(len(l) > n))
postcondition: exception thrown

precondition: len(l) > n && !(n < 0)
postcondition: terminates normally
```

#### List.mem

```
precondition: false
postcondition: exception thrown

precondition: true
postcondition: terminates normally

precondition: for any le in l -> m = le
postcondition: res = true
```

### Mutators

#### List.tl

```
precondition: len(l) = 0
postcondition: exception thrown

precondition: !(len(l) = 0)
postcondition: terminates normally

precondition: (! ((tl x0g) = []))
postcondition: len(res) > 0

precondition: !((! ((tl x0g) = [])))
postcondition: len(res) = 0

precondition: false
postcondition: l = res

precondition: true
postcondition: len(l) > len(res)

precondition: false
postcondition: len(l) = len(res)
```

#### List.append

```
precondition: false
postcondition: exception thrown

precondition: true
postcondition: terminates normally

precondition: (!(l0  l1) || for any l0e in l0 -> for any l1e in l1 -> l0e = l1e)
postcondition: len(res) > 0

precondition: len(l1) = 0 && len(l0) = len(l1)
postcondition: len(res) = 0

precondition: true
postcondition: len(res) = len(l0)+len(l1)

precondition: false
postcondition: len(res) != len(l0)+len(l1)
```

#### List.combine

```
precondition: !(len(l0) = len(l1))
postcondition: exception thrown

precondition: len(l0) = len(l1)
postcondition: terminates normally

precondition: !(len(l1) = 0)
postcondition: len(res) > 0

precondition: len(l1) = 0
postcondition: len(res) = 0
```

#### List.concat

```
precondition: false
postcondition: exception thrown

precondition: true
postcondition: terminates normally

precondition: for any le in l -> len(le) > 0
postcondition: len(res) > 0

precondition: !(for any le in l -> len(le) > 0)
postcondition: len(res) = 0

precondition: ~~~ FAILED ~~~
postcondition: len(l) > len(res)

precondition: ~~~ FAILED ~~~
postcondition: len(l) = len(res)

precondition: false
postcondition: len(res) > sum(len(l0:lN))

precondition: true
postcondition: len(res) = sum(len(l0:lN))

precondition: false
postcondition: len(res) < sum(len(l0:lN))
```

#### List.flatten

```
precondition: false
postcondition: exception thrown

precondition: true
postcondition: terminates normally

precondition: for any le in l -> len(le) > 0
postcondition: len(res) > 0

precondition: !(for any le in l -> len(le) > 0)
postcondition: len(res) = 0

precondition: ~~~ FAILED ~~~
postcondition: len(l) > len(res)

precondition: ~~~ FAILED ~~~
postcondition: len(l) = len(res)

precondition: false
postcondition: len(res) > sum(len(l0:lN))

precondition: true
postcondition: len(res) = sum(len(l0:lN))

precondition: false
postcondition: len(res) < sum(len(l0:lN))
```

#### List.rev

```
precondition: false
postcondition: exception thrown

precondition: true
postcondition: terminates normally

precondition: !(len(a) = 0)
postcondition: len(res) > 0

precondition: len(a) = 0
postcondition: len(res) = 0

precondition: (x0g = (rev x0g))
postcondition: a = res

precondition: false
postcondition: len(a) > len(res)

precondition: true
postcondition: len(a) = len(res)
```

#### List.rev_append

```
precondition: false
postcondition: exception thrown

precondition: true
postcondition: terminates normally

precondition: (!(l0 = l1) || for any l0e in l0 -> for any l1e in l1 -> l0e = l1e)
postcondition: len(res) > 0

precondition: len(l1) = 0 && len(l0) = len(l1)
postcondition: len(res) = 0

precondition: true
postcondition: len(res) = len(l0)+len(l1)

precondition: false
postcondition: len(res) != len(l0)+len(l1)
```

#### List.split

```
precondition: false
postcondition: exception thrown

precondition: true
postcondition: terminates normally

precondition: !(len(l) = 0)
postcondition: len(r0) > 0

precondition: len(l) = 0
postcondition: len(r0) = 0

precondition: !(len(l) = 0)
postcondition: len(r1) > 0

precondition: len(l) = 0
postcondition: len(r1) = 0

precondition: false
postcondition: len(r0) > len(r1)

precondition: true
postcondition: len(r0) = len(r1)
```