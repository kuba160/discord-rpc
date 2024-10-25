CC?=gcc
CXX?=g++
SRC_DIR := ./src
SRC_FILES := $(wildcard $(SRC_DIR)/*.cpp)
ifeq ($(OS),Windows_NT)
    SRC_FILES := $(filter-out $(SRC_DIR)/connection_unix.cpp $(SRC_DIR)/discord_register_linux.cpp, $(SRC_FILES))
else
    SRC_FILES := $(filter-out $(SRC_DIR)/connection_win.cpp $(SRC_DIR)/discord_register_win.cpp $(SRC_DIR)/dllmain.cpp, $(SRC_FILES))
endif

OBJ_FILES := $(patsubst $(SRC_DIR)/%.cpp,$(SRC_DIR)/%.o,$(SRC_FILES))
CXXFLAGS += -I ../thirdparty/rapidjson-1.1.0/include -I ./thirdparty/rapidjson-1.1.0/include -I ./include -DDISCORD_LINUX -std=gnu++11 -fPIC
RAPIDJSON = thirdparty/rapidjson-1.1.0

all: $(RAPIDJSON) libdiscord-rpc.a

libdiscord-rpc.a: $(OBJ_FILES)
	ar rcs src/$@ $^

$(SRC_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -c -o $@ $<

clean:
	rm -f $(SRC_DIR)/*.o
	rm -f $(SRC_DIR)/*.a

$(RAPIDJSON):
	echo "Downloading rapidjson"
	wget -N -P thirdparty/ https://github.com/miloyip/rapidjson/archive/v1.1.0.tar.gz
	tar xzf thirdparty/v1.1.0.tar.gz -C thirdparty/
	rm thirdparty/v1.1.0.tar.gz
	cd thirdparty/rapidjson-1.1.0/ && patch -p1 -i ../../../01-rapidjson.patch
