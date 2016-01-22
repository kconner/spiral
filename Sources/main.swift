#!/usr/bin/env swift

func main(arguments: [String]) {
	guard arguments.count == 2,
		let countString = arguments.last,
		let count = Int(countString) where 0 < count
		else
	{
		print("Usage: spiral <positive integer>")
		return
	}
	
	print(spiralStringWithRange(1...count))
}

main(Process.arguments)
