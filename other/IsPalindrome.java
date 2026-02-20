public class IsPalindrome {

    public static void main(String[] args) {
        System.out.println(isPalindrome("mad23am"));
    }

    public static String isPalindrome(String s){

        if(s.isEmpty()){
            return "It is palindrome";
        }

        if(s.charAt(0) != s.charAt(s.length()-1)){
            return "Not palindrome";
        }else{
            
            String newS = s.substring(1, s.length()-1);
            
            if(newS.length() == 1){
                return "It is palindrome";
            }else if(newS.length() == 2){

                if(newS.charAt(0) != newS.charAt(newS.length()-1)){
                    return "Not palindrome";
                }else {
                    return "It is palindrome";
                }
                
            }else{
                return isPalindrome(newS);
            }

        }

    }
}
