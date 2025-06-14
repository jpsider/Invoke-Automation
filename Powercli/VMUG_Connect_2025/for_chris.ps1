function function1{
    [CmdletBinding()]param()
    try{
        function2 -ErrorAction stop
    }
    catch {
        write-host "Function2 threw an error"
    }
    finally{
        write-host "this is the finally from function1"
    }
}

function function2{
    [CmdletBinding()]param()
    try{
        function3
    }
    catch {
        write-host "This is the function 2 catch block"
    }
    finally {
        write-host "This is the finally from function2"
    }
}
function function3{
    [CmdletBinding()]param()
    throw "game over"
}
