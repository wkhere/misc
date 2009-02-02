abstype foo = Foo|Bar of int|Quux of foo
with
	val empty=Foo 
	fun bar x = Bar x
	fun quux v = Quux v
end
