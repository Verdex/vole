
test: test_vec
	./test_vec


test_vec: 
	clang test_vec.c -o test_vec


clean: 
	rm -rf *.o 
	rm -rf test_vec 
	rm -rf a.out 
