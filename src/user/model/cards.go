package model

import (
	"fmt"
	"strings"
)

type Card struct {
	LongNum string `json:"longNum" bson:"longNum"`
	Expires string `json:"expires" bson:"expires"`
	CCV     string `json:"ccv" bson:"ccv"`
}

func (c *Card) MaskCC() {
	l := len(c.LongNum) - 4
	c.LongNum = fmt.Sprintf("%v%v", strings.Repeat("*", l), c.LongNum[l:])
}
