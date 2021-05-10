package main

import (
	"fmt"
	"net/http"
	"os"
	"os/exec"

	"github.com/Monkey-Mouse/mo2/server/middleware"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()
	middleware.H.PostWithRL("/post", func(ctx *gin.Context) {
		dir, _ := os.Getwd()
		fmt.Println("enter", dir)
		ex := exec.Command("/bin/bash", "./k8sImageUpdate.bash")
		fmt.Println("exec")

		cmd, err := ex.Output()
		if err != nil {
			fmt.Println(string(err.(*exec.ExitError).Stderr))
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
