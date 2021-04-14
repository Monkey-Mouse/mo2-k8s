package main

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"

	"github.com/Monkey-Mouse/mo2/server/middleware"
	"github.com/gin-gonic/gin"
)

type nilRoleHolder struct {
}

func (h *nilRoleHolder) IsInRole(role string) bool {
	return true
}

func main() {
	r := gin.Default()
	middleware.H.PostWithRL("/post", func(ctx *gin.Context) {
		dir, _ := os.Getwd()
		fmt.Println("enter", dir)
		ex := exec.Command("/bin/bash", "./refresh.bash")
		fmt.Println("exec")
		cmd, err := ex.Output()
		if err != nil {
			fmt.Println(err)
		}
		fmt.Println(string(cmd))
		ctx.JSON(http.StatusOK, nil)
	}, 1)
	middleware.H.RegisterMapedHandlers(r, &middleware.OptionalParams{
		LimitEvery:   10,
		Unblockevery: 3600,
		UseRedis:     false,
	})
	r.Run(":5002")
}
