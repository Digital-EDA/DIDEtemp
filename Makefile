# 仿真参数设置
SIM_VERSION:= v0.3
PRJ_PATH:=prj
SIM_PATH:= ${PRJ_PATH}/SIM${SIM_VERSION}
# SIM_FILE:= /home/icer/Project/library/user/sim/Basic/Memory/SRAM/Shift/shiftTaps/shiftTaps.f
# SIM_FILE:= ${USR_PATH}/sim/basic.f
SIM_FILE:= user/sim/FFT_IFFT.f
# SIM_FILE:= /home/icer/Project/library/user/sim/Basic/Math/Advance/FFT/FFT_IFFT.f
SIM_NAME:= FFT_IFFT

SIM_ARGE:= -f ${SIM_FILE}
SIM_ARGE+= -o ${SIM_NAME}
SIM_ARGE+= -l ./vcs.log
SIM_ARGE+= +v2k # 是使VCS兼容verilog 2001以前的标准
SIM_ARGE+= -full64 # 只使用 64 位的库
SIM_ARGE+= -debug_all # 用于产生debug所需的文件
SIM_ARGE+= +vcs+initreg+random
SIM_ARGE+= +notimingcheck
# SIM_ARGE+= -xprop
SIM_ARGE+= -Mupdate # 增量编译
SIM_ARGE+= -ucli # 使用用户命令行进行仿真调试
# SIM_ARGE+= -gui
SIM_ARGE+= -error=IWNF +lint=TFIPC-L # 加强约束
SIM_ARGE+= $(CM) $(CM_NAME) $(CM_DIR) # 覆盖率选项

# Code coverage command  #覆盖率检查
CM = -cm line+cond+fsm+branch+tgl #收集的代码覆盖率类型
CM_NAME = -cm_name $(SIM_NAME) #表示覆盖率的文件名
CN_DIR  = -cm_dir ${SIM_PATH}/$(SIM_NAME).vdb #覆盖率文件的存放目录

.PHONY: sim
sim :
	-mkdir ${PRJ_PATH}
	rm -rf ${SIM_PATH} && mkdir ${SIM_PATH}
	cd ${SIM_PATH} && vcs ${SIM_ARGE}
	cd ${SIM_PATH} && ./${SIM_NAME}