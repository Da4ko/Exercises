public class SelectionSort {
    public static void main(String[] args) {
        int[] arr = {64, 25, 12, 22, 11};
        selectionSort(arr);
    }

    public static void selectionSort(int[] array){
        for (int i = 0; i < array.length; i++) {
            int currentMin = array[i];
            int currentMinIndex = i;
            for (int j = i; j < array.length; j++) {
                if(array[j]<currentMin){
                    currentMin = array[j];
                    currentMinIndex = j;
                }
            }
            int temp = array[i];
            array[i] = array[currentMinIndex];
            array[currentMinIndex] = temp;
        }
        for(int i : array){
            System.out.println(i);
        }
    }
}
