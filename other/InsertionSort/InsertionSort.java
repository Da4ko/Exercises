public class InsertionSort {
    public static void main(String[] args) {
        int[] arrToSort = {5,2,9,1,5,6};
        sortArray(arrToSort);

    }

    public static void sortArray(int[] array){
        for (int i = 1; i < array.length; i++) {
            for (int j = i-1; j >= 0; j--) {
                if(array[j+1]<=array[j]){
                    int temp = array[j+1];
                    array[j+1]=array[j];
                    array[j]=temp;
                }else{
                    break;
                }
            }
        }
        for(int i : array){
            System.out.print(i+" ");
        }
    }
}
