wait:
ifeq ($(OS),Windows_NT)
	timeout 5
else
	sleep 5
endif
